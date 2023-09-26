Import sqluser

Class web.DHCADVLELSTATIC Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 不良反应等级统计
/// Creator:     CongYue
/// CreateDate:  2016-04-06  
/// Input:  	 开始日期^结束日期"2016-02-02^2016-02-02^等级"
/// Output:   	 非不良事件个数^一级事件个数^二级事件个数^三级事件个数^四级事件个数^报告总数
/// Others:		 d ##class(web.DHCADVLELSTATIC).QueryLelStatic("2016-11-01^2016-11-17^^")
ClassMethod QueryLelStatic(params As %String) As %String
{
	N (params)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	D ..killTmpGlobal(pid)
	d ..StaTicRep(params,pid)
	S LevelDr=""
	S Numalls=0
	F  S LevelDr=$o(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr)) Q:LevelDr=""  D
	.S Numall=$p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr),"^",3)
	.S ListData=$g(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr))
	.S ^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,+Numall,LevelDr)=ListData
	.S Numalls=Numalls+Numall
	S ^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,"-100","合计")="合计"_"^"_"报告数量"_"^"_Numalls
	S ListTitle="name^group^value"
	W "["
	S count=""
	S index=""
	S Num=0
	F  S count=$o(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,count),-1) Q:count=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,count,index)) Q:index=""  D
	..S ListData=$g(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,count,index))
	..Q:ListData=""
	..S Num=Num+1
	..I Num=1 D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	..
	.
	W "]"
	D ..killTmpGlobal(pid)
	Q ""
}

/// Description: 不良反应报告统计
/// Creator:     CongYue
/// CreateDate:  2016-04-06  
/// Input:  	 开始日期^结束日期"2016-02-02^2016-02-02^等级"
/// Output:   	 非不良事件个数^一级事件个数^二级事件个数^三级事件个数^四级事件个数^报告总数
/// Others:		 w ##class(web.DHCADVLELSTATIC).StaTicRep("2016-11-01^2016-11-17^^","")
ClassMethod StaTicRep(params As %String, pid As %String) As %String
{
	N (params,pid)
	S StDate=$p(params,"^",1)       //开始日期
	S EndDate=$p(params,"^",2)      //结束日期
	S StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)  //$zdh(StDate,3)
	S EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)  //$zdh(EndDate,3)
	S Level=$p(params,"^",3)      //不良事件等级
	s TypeEvent=$p(params,"^",4) //报告类型
	i TypeEvent'="" d
	.s TypeCode=$p(^DHCMEDADREVT(TypeEvent),"^",1)
	e  d
	.s TypeCode=""
	S Repnum=0
	S NUM=1
	F dd=StDate:1:EndDate D
	.;医疗                                     //wangxuejian 2016/11/7
	.if ((TypeCode="med")||(TypeCode="")) d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCMEDADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCMEDADRR(MedsrID),"^",27) //当前状态
	...Q:StatusID=""
	...S typedr=$p(^DHCMEDADRR(MedsrID),"^",30) //类型ID
	...Q:typedr=""
	...S Typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...Q:(Typecode'="med")
	...S ID=""
	...;S Pointer=""
	...;F  S Pointer=$o(^DHCMEDADRR(0,"CreateDate",dd,Pointer))  Q:Pointer=""  D 
	...;F  S ID=$o(^DHCADVREPMAN(0,"Pointer",MedsrID,ID))  Q:ID=""  D
	...F  S ID=$o(^DHCADVREPMAN(0,"TyepPointer",typedr,MedsrID,ID))  Q:ID=""  D
	....S LevelDr=$p(^DHCADVREPMAN(ID),"^",3)
	....Q:LevelDr=""
	....S LevelDesc=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	....Q:(Level'="")&(LevelDr'[Level)
	....i $D(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")) D
	.....S $p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)=$p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)+NUM
	....E  S ^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")=LevelDesc_"^"_"报告数量"_"^"_NUM
	.;药品
	.if ((TypeCode="drug")||(TypeCode="")) d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCADVDRUGREP(MedsrID),"^",48) //当前状态
	...Q:StatusID=""
	...S typedr=$p(^DHCADVDRUGREP(MedsrID),"^",49) //类型ID
	...Q:typedr=""
	...S Typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...Q:(Typecode'="drug")
	...S ID=""
	...;S Pointer=""
	...;F  S Pointer=$o(^DHCMEDADRR(0,"CreateDate",dd,Pointer))  Q:Pointer=""  D 
	...;F  S ID=$o(^DHCADVREPMAN(0,"Pointer",MedsrID,ID))  Q:ID=""  D
	...F  S ID=$o(^DHCADVREPMAN(0,"TyepPointer",typedr,MedsrID,ID))  Q:ID=""  D
	....S LevelDr=$p(^DHCADVREPMAN(ID),"^",3)
	....Q:LevelDr=""
	....S LevelDesc=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	....Q:(Level'="")&(LevelDr'[Level)
	....i $D(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")) D
	.....S $p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)=$p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)+NUM
	....E  S ^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")=LevelDesc_"^"_"报告数量"_"^"_NUM
	.;输血不良事件
	.if ((TypeCode="bldevent")||(TypeCode="")) d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCMEDADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCMEDADRR(MedsrID),"^",27) //当前状态
	...Q:StatusID=""
	...S typedr=$p(^DHCMEDADRR(MedsrID),"^",30) //类型ID
	...Q:typedr=""
	...S Typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...Q:(Typecode'="bldevent")
	...S ID=""
	...;S Pointer=""
	...;F  S Pointer=$o(^DHCMEDADRR(0,"CreateDate",dd,Pointer))  Q:Pointer=""  D 
	...;F  S ID=$o(^DHCADVREPMAN(0,"Pointer",MedsrID,ID))  Q:ID=""  D
	...F  S ID=$o(^DHCADVREPMAN(0,"TyepPointer",typedr,MedsrID,ID))  Q:ID=""  D
	....S LevelDr=$p(^DHCADVREPMAN(ID),"^",3)
	....Q:LevelDr=""
	....S LevelDesc=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	....Q:(Level'="")&(LevelDr'[Level)
	....i $D(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")) D
	.....S $p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)=$p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)+NUM
	....E  S ^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")=LevelDesc_"^"_"报告数量"_"^"_NUM
	.;器械
	.if ((TypeCode="material")||(TypeCode="")) d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCMATADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCMATADRR(MedsrID),"^",41) //当前状态
	...Q:StatusID=""
	...S typedr=$p(^DHCMATADRR(MedsrID),"^",46) //类型ID
	...Q:typedr=""
	...S Typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...s ^TMP("ww")=Typecode
	...Q:(Typecode'="material")
	...S ID=""
	...;S Pointer=""
	...;F  S Pointer=$o(^DHCMEDADRR(0,"CreateDate",dd,Pointer))  Q:Pointer=""  D 
	...;F  S ID=$o(^DHCADVREPMAN(0,"Pointer",MedsrID,ID))  Q:ID=""  D
	...F  S ID=$o(^DHCADVREPMAN(0,"TyepPointer",typedr,MedsrID,ID))  Q:ID=""  D
	....S LevelDr=$p(^DHCADVREPMAN(ID),"^",3)
	....Q:LevelDr=""
	....S LevelDesc=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	....Q:(Level'="")&(LevelDr'[Level)
	....i $D(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")) D
	.....S $p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)=$p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)+NUM
	....E  S ^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")=LevelDesc_"^"_"报告数量"_"^"_NUM
	.;输血
	.if ((TypeCode="blood")||(TypeCode="")) d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCBLDADVRPT(MedsrID),"^",46) //当前状态
	...Q:StatusID=""
	...S typedr=$p(^DHCBLDADVRPT(MedsrID),"^",47) //类型ID
	...Q:typedr=""
	...S Typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...Q:(Typecode'="blood")
	...S ID=""
	...;S Pointer=""
	...;F  S Pointer=$o(^DHCMEDADRR(0,"CreateDate",dd,Pointer))  Q:Pointer=""  D 
	...;F  S ID=$o(^DHCADVREPMAN(0,"Pointer",MedsrID,ID))  Q:ID=""  D
	...F  S ID=$o(^DHCADVREPMAN(0,"TyepPointer",typedr,MedsrID,ID))  Q:ID=""  D
	....S LevelDr=$p(^DHCADVREPMAN(ID),"^",3)
	....Q:LevelDr=""
	....S LevelDesc=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	....Q:(Level'="")&(LevelDr'[Level)
	....i $D(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")) D
	.....S $p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)=$p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)+NUM
	....E  S ^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")=LevelDesc_"^"_"报告数量"_"^"_NUM
	.;用药差错
	.if ((TypeCode="drugerr")||(TypeCode="")) d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCADVMEDSAR(MedsrID),"^",18) //当前状态
	...Q:StatusID=""
	...S typedr=$p(^DHCADVMEDSAR(MedsrID),"^",20) //类型ID
	...Q:typedr=""
	...S Typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...Q:(Typecode'="drugerr")
	...S ID=""
	...;S Pointer=""
	...;F  S Pointer=$o(^DHCMEDADRR(0,"CreateDate",dd,Pointer))  Q:Pointer=""  D 
	...;F  S ID=$o(^DHCADVREPMAN(0,"Pointer",MedsrID,ID))  Q:ID=""  D
	...F  S ID=$o(^DHCADVREPMAN(0,"TyepPointer",typedr,MedsrID,ID))  Q:ID=""  D
	....S LevelDr=$p(^DHCADVREPMAN(ID),"^",3)
	....Q:LevelDr=""
	....S LevelDesc=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	....Q:(Level'="")&(LevelDr'[Level)
	....i $D(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")) D
	.....S $p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)=$p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级"),"^",3)+NUM
	....E  S ^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr_"级")=LevelDesc_"^"_"报告数量"_"^"_NUM
	Q ""
}

/// Description: 不良反应等级分析
/// Creator:     CongYue
/// CreateDate:  2016-04-06  
/// Input:  	 开始日期^结束日期"2016-02-02^2016-02-02^等级"
/// Output:   	 非不良事件个数^一级事件个数^二级事件个数^三级事件个数^四级事件个数^报告总数
/// Others:		 d ##class(web.DHCADVLELSTATIC).QueryLelAnalysis("2016-03-30^2016-04-01^")
ClassMethod QueryLelAnalysis(params As %String) As %String
{
	N (params)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	D ..killTmpGlobal(pid)
	d ..StaTicRep(params,pid)
	S LevelDr=""
	S Numalls=0
	F  S LevelDr=$o(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr)) Q:LevelDr=""  D
	.S Numall=$p(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr),"^",3)
	.S ListData=$g(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,LevelDr))
	.S ^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,+Numall,LevelDr)=ListData
	
	S ListTitle="name^group^value"
	W "["
	S count=""
	S index=""
	S Num=0
	F  S count=$o(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,count),-1) Q:count=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,count,index)) Q:index=""  D
	..S ListData=$g(^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid,count,index))
	..Q:ListData=""
	..S Num=Num+1
	..I Num=1 D
	...W ##class(web.DHCADVJSONCOMMON).getSisJsonData(ListTitle,ListData)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getSisJsonData(ListTitle,ListData)
	..
	.
	W "]"
	D ..killTmpGlobal(pid)
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCADV","web.DHCADVLELSTATIC","QueryLelStatic",pid)
}

}
