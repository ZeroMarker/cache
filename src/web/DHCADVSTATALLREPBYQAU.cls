Import sqluser

Class web.DHCADVSTATALLREPBYQAU Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 不良事件按季度统计
/// Creator:     yangyongtao
/// CreateDate:  2016-03-24 
/// Input:  	 年份^报告类型^季度"
/// Output:   	 季度^器械的数量^器械的总数量
/// Others:		 d ##class(web.DHCADVSTATALLREPBYQAU).StatAllRepByQau("12","1","2015")
ClassMethod StatAllRepByQau(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End = page*rows
    s Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
    d ..killTmpGlobal(pid) //k掉临时global
    s DateYear=$p(params,"^",1) //年份
	S TypeEvent=$p(params,"^",2) //类型
	S SeasonType=$p(params,"^",3) //季度
	i TypeEvent'="" d
	.s TypeCode=$p(^DHCMEDADREVT(TypeEvent),"^",1)
	e  d
	.s TypeCode=""
	s h=0,count=0
	S Numalls=0   //合计初始化
    s Num=1       //月份器械类型数量统计初始化
	i SeasonType=""  s SeasonType="1,2,3,4"
    f SeasonLength=1:1:$l(SeasonType,",") d
    .s Season=$p(SeasonType,",",SeasonLength)
    .I Season=1  s StDate=DateYear_"-01-01"  s EndDate=DateYear_"-03-31"  
    .I Season=2  s StDate=DateYear_"-04-01"  s EndDate=DateYear_"-06-30" 
    .I Season=3  s StDate=DateYear_"-07-01"  s EndDate=DateYear_"-09-30"  
    .I Season=4  s StDate=DateYear_"-10-01"  s EndDate=DateYear_"-12-31"  
	.s StDate=$zdh(StDate,3)
	.s EndDate=$zdh(EndDate,3)
	.f dd=StDate:1:EndDate d
	..
	..;用药差错
	..if (TypeCode="drugerr")||(TypeCode="") d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCADVMEDSAR(MedsrID),"^",18) //报告状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCADVMEDSAR(MedsrID),"^",20) //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)       //类型Desc
	....S Numalls=Numalls+1
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  d
	.....s h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)=Season_"^"_"报告数量"_"^"_Num
	..
	..;输血
	..if (TypeCode="blood")||(TypeCode="")  d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCBLDADVRPT(MedsrID),"^",46)   //报告状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCBLDADVRPT(MedsrID),"^",47)  //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)      //类型Desc
	....S Numalls=Numalls+1
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  d
	.....s h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)=Season_"^"_"报告数量"_"^"_Num
	..
	..;器械
	..if (TypeCode="material")||(TypeCode="")  d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCMATADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCMATADRR(MedsrID),"^",41)   //报告状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCMATADRR(MedsrID),"^",46)   //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)       //类型Desc
	....S Numalls=Numalls+1
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  d
	.....s h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)=Season_"^"_"报告数量"_"^"_Num
	..
	..;药品
	..if (TypeCode="drug")||(TypeCode="") d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCADVDRUGREP(MedsrID),"^",48)  //报告状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCADVDRUGREP(MedsrID),"^",49)  //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)     //类型Desc
	....S Numalls=Numalls+1
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  d
	.....s h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)=Season_"^"_"报告数量"_"^"_Num
	..
	..;医疗
	..if (TypeCode="med")||(TypeCode="") d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCMEDADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCMEDADRR(MedsrID),"^",27) //当前状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCMEDADRR(MedsrID),"^",30) //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	....Q:(typecode'="med")
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)    //类型Desc
	....S Numalls=Numalls+1
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  d
	.....s h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)=Season_"^"_"报告数量"_"^"_Num
	..
	..;输血不良事件
	..if (TypeCode="bldevent")||(TypeCode="") d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCMEDADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCMEDADRR(MedsrID),"^",27) //当前状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCMEDADRR(MedsrID),"^",30) //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1) //类型Code
	....Q:(typecode'="bldevent")
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)  //类型Desc
	....S Numalls=Numalls+1
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  d
	.....s h=h+1  
	.....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)=Season_"^"_"报告数量"_"^"_Num
	..
	.
	S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,100)="合计:"_"^"_"报告数量"_"^"_Numalls
	i h=0 w ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	///转换数据为Json格式
	S Title="name^group^value"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h+1) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,index))
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

/// Description: 不良事件按季度统计分析
/// Creator:     yangyongtao
/// CreateDate:  2016-03-24 
/// Input:  	 年份^报告类型^季度"
/// Output:   	 季度^器械的数量^器械的总数量
/// Others:		 d ##class(web.DHCADVSTATALLREPBYQAU).AnalysisRepByQau("2016^^1,2,3,4")
ClassMethod AnalysisRepByQau(params As %String) As %String
{
	n (params)
	s ^tll(params)=""
    S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
    d ..killTmpGlobal(pid) //k掉临时global
    s DateYear=$p(params,"^",1) //年份
	S TypeEvent=$p(params,"^",2) //类型
	S SeasonType=$p(params,"^",3) //季度
	i TypeEvent'="" d
	.s TypeCode=$p(^DHCMEDADREVT(TypeEvent),"^",1)
	e  d
	.s TypeCode=""
	s h=0,count=0
	S Numalls=0   //合计初始化
    s Num=1       //月份器械类型数量统计初始化
	i SeasonType=""  s SeasonType="1,2,3,4"
    f SeasonLength=1:1:$l(SeasonType,",") d
    .s Season=$p(SeasonType,",",SeasonLength)
    .q:Season="" 
    .I Season=1  s StDate=DateYear_"-01-01"  s EndDate=DateYear_"-03-31"  
    .I Season=2  s StDate=DateYear_"-04-01"  s EndDate=DateYear_"-06-30" 
    .I Season=3  s StDate=DateYear_"-07-01"  s EndDate=DateYear_"-09-30"  
    .I Season=4  s StDate=DateYear_"-10-01"  s EndDate=DateYear_"-12-31"  
	.s StDate=$zdh(StDate,3)
	.s EndDate=$zdh(EndDate,3)
	.f dd=StDate:1:EndDate d
	..
	..;用药差错
	..if (TypeCode="drugerr")||(TypeCode="") d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCADVMEDSAR(MedsrID),"^",18) //报告状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCADVMEDSAR(MedsrID),"^",20) //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)       //类型Desc
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)="第"_Season_"季度"_"^"_"报告数量"_"^"_Num
	..
	..;输血
	..if (TypeCode="blood")||(TypeCode="")  d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCBLDADVRPT(MedsrID),"^",46)   //报告状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCBLDADVRPT(MedsrID),"^",47)  //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)      //类型Desc
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)="第"_Season_"季度"_"^"_"报告数量"_"^"_Num
	..
	..;器械
	..if (TypeCode="material")||(TypeCode="")  d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCMATADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCMATADRR(MedsrID),"^",41)   //报告状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCMATADRR(MedsrID),"^",46)   //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)       //类型Desc
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)="第"_Season_"季度"_"^"_"报告数量"_"^"_Num
	..
	..;药品
	..if (TypeCode="drug")||(TypeCode="") d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCADVDRUGREP(MedsrID),"^",48)  //报告状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCADVDRUGREP(MedsrID),"^",49)  //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)     //类型Desc
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)="第"_Season_"季度"_"^"_"报告数量"_"^"_Num
	..
	..;医疗
	..if (TypeCode="med")||(TypeCode="") d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCMEDADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCMEDADRR(MedsrID),"^",27) //当前状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCMEDADRR(MedsrID),"^",30) //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	....Q:(typecode'="med")
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)    //类型Desc
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)="第"_Season_"季度"_"^"_"报告数量"_"^"_Num
	..
    ..;输血不良事件
	..if (TypeCode="bldevent")||(TypeCode="") d
	...s MedsrID="0"
	...f  s MedsrID=$o(^DHCMEDADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	....S StatusID=$p(^DHCMEDADRR(MedsrID),"^",27) //当前状态
	....;Q:StatusID=""
	....S typedr=$p(^DHCMEDADRR(MedsrID),"^",30) //类型ID
	....Q:typedr=""
	....S typecode=$p(^DHCMEDADREVT(typedr),"^",1) //类型Code
	....Q:(typecode'="bldevent")
	....S type=$p(^DHCMEDADREVT(typedr),"^",2)  //类型Desc
	....i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season))  d
	.....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season),"^",3)+1
	....E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,Season)="第"_Season_"季度"_"^"_"报告数量"_"^"_Num

	.
	///转换数据为Json格式
	S Title="name^group^value"
	W "["    
	S Num=0
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid,index))
	.Q:mdate=""
	.S Num=Num+1
	.I Num=1 D
	..W ##class(web.DHCADVJSONCOMMON).getSisJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getSisJsonData(Title,mdate)
	.
	W "]"
	D ..killTmpGlobal(pid)
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	;k ^TMP("DHCADV","web.DHCADVSTATALLREPBYQAU","QueryStatAllRepByQau",pid)
}

}
