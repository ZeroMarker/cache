Class web.DHCEMCalPatLevel Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

// d ##class(User.DHCEmLevTheItm).%BuildIndices($ListBuild("IndexLev"))

/// description:计算病人级别
/// input:DHC_EmPatCheckLev rowid
/// input:收缩压^血氧饱合度SoP2^心率^意识形态^既往史1$$既往史2^体温^症状1$$症状2^疼痛分级^舒张压^年龄^呼吸频率^哥斯拉
/// return:病人级别
/// w ##class(web.DHCEMCalPatLevel).calPatLevel("^^^^^^^^^^^12^")
ClassMethod calPatLevel(EmPCLvID As %String) As %String
{
		n (EmPCLvID,%session)
		;s hosp=2 //hxy 2020-12-26 注释 st
		s:$d(%session) hosp=%session.Get("LOGON.HOSPID") //放开注释
		
		s hosp=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmLevTheme",hosp) //add ed
		
		s %EmPCLvID=EmPCLvID
		//s $ZT="Err"
		
		s tmplev="",flag=0,themeid=0
		f  s tmplev=$o(^DHCEMLTH(tmplev)) q:(tmplev="")||(flag'=0)   d
		.q:+tmplev=0
		.q:$p(^DHCEMLTH(tmplev),"^",3)'="Y"   ///遍历所有主题，选取为Y的
		.s tmphosp=$P(^DHCEMLTH(tmplev),"^",5)  ///医院ID
		.;q:(+tmphosp'=0)&&(hosp'=tmphosp) //hxy 2020-12-28 注释
		.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmLevTheme",tmplev,hosp)'="Y" //hxy 2020-12-28 add 基础数据 走基础数据平台接口
		.s themeid=tmplev
		.i $p(^DHCEMLTH(tmplev),"^",4)="SUM"  d
		..s flag=2                    ///flag=2是走总分的
		.e  d	
		..s flag=1					  ///flag=1走的是单个分级
		
		s lev=0,level=0
		//取符合入参级别最高的
		i (flag=1)&&(themeid>0) d    ///这个是走单个分级来的
		.
		.f  s lev=$o(^DHCEMLTH(0,"Lev","Y",lev)) q:(lev="")||(level'=0)   d	 //主题id
		..s sub=""
		..f  s sub=$o(^DHCEMLTH(0,"Lev","Y",lev,themeid,sub)) q:(sub="")||(level'=0)  d	 //遍历等级下数据,从1
		...q:'$d(^DHCEMLTH(themeid,"L",sub))
		...q:$p(^DHCEMLTH(themeid,"L",sub),"^",3)'="Y"
		...q:level'=0
		...q:lev'=$p(^DHCEMLTH(themeid,"L",sub),"^",1)	      ///分级指标表达式库明细表
		...s phid=$p(^DHCEMLTH(themeid,"L",sub),"^",2)        ///这个就是表达式的ID
		...q:+phid=0
		...q:'$d(^DHCEMLEX(phid))
		...s text=$p(^DHCEMLEX(phid),"^",3)                   ///表达式
		...s runStr=##Class(web.DHCEMCalExpress).changeExpression(text)
		...
		...s runStr="s ret="_runStr
		...x runStr
		...s:ret=1 level=lev,^ZXZX=runStr                   
		...//w "text:"_runStr_"@@"_ret_"@@"_themeid_"@@"_sub_"@@"_lev,!
		
		//取所有
		i (flag=2)&&(themeid>0) d
		.s lev=0
		.f  s lev=$o(^DHCEMLTH(0,"Lev","Y",lev)) q:lev=""   d	 //主题id
		..s sub=""
		..f  s sub=$o(^DHCEMLTH(0,"Lev","Y",lev,themeid,sub)) q:sub=""  d	 //遍历等级下数据
		...q:'$d(^DHCEMLTH(themeid,"L",sub))
		...q:$p(^DHCEMLTH(themeid,"L",sub),"^",3)'="Y"
		...s phid=$p(^DHCEMLTH(themeid,"L",sub),"^",2)
		...q:+phid=0
		...q:'$d(^DHCEMLEX(phid))
		...s text=$p(^DHCEMLEX(phid),"^",3)
		...s runStr=##Class(web.DHCEMCalExpress).changeExpression(text)
		...s runStr="s ret="_runStr
		...x runStr
		...i ret=1 d
		....s level=level+$p(^DHCEMLTH(themeid,"L",sub),"^",1)
		.i $p(^DHCEMLTH(themeid),"^",1)["MEWS" d //=
		..s level=$SELECT(level>=9:1,level>=7:2,level>=5:3,level>=3:4,1:"")   ///qqa 2017-09-01 
		.
		q level
Err
  s ^ZXZX="runStr:"_$g(runStr)_"lev:"_$g(lev)
  q 0
}

/// d ##class(web.DHCEMCalPatLevel).test()
ClassMethod test(EmPCLvID As %String) As %String
{
		s %EmPCLvID=1
		w ..getPatHR()
}

/// 获取心率
/// input:DHC_EmPatCheckLev rowid
ClassMethod getPatHR() As %String
{
		
		New (%EmPCLvID,%RetData)
		Set %RetData=0
		Set %EmPCLvID=$g(%EmPCLvID)
		Quit:%EmPCLvID=""
		q:$f(%EmPCLvID,"^")>0 $p(%EmPCLvID,"^",3) 
		s EmPcsID=""
		
	 	s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",%EmPCLvID,EmPcsID),-1)
		q:EmPcsID="" 
		s %RetData=$p(^DHCEMPCS(EmPcsID),"^",4)
		q $p(^DHCEMPCS(EmPcsID),"^",4)
}

/// 获取体温
/// input:DHC_EmPatCheckLev rowid
ClassMethod getPatTemp() As %String
{
		
		New (%EmPCLvID,%RetData)
		Set %RetData=0
		Set %EmPCLvID=$g(%EmPCLvID)
		Quit:%EmPCLvID="" 
		q:$f(%EmPCLvID,"^")>0 $p(%EmPCLvID,"^",6)
		s EmPcsID=""
	 	s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",%EmPCLvID,EmPcsID),-1)
		q:EmPcsID="" 
		s %RetData=$p(^DHCEMPCS(EmPcsID),"^",3)
		q $p(^DHCEMPCS(EmPcsID),"^",3)
}

/// 获取脉搏
/// input:DHC_EmPatCheckLev rowid
ClassMethod getPatPulse() As %String
{
		
		New (%EmPCLvID,%RetData)
		Set %RetData=0
		Set %EmPCLvID=$g(%EmPCLvID)
		Quit:%EmPCLvID="" 
		q:$f(%EmPCLvID,"^")>0 $p(%EmPCLvID,"^",10) ;2016-12-06 congyue
		s EmPcsID=""
	 	s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",%EmPCLvID,EmPcsID),-1)
		q:EmPcsID="" 
		s %RetData=$p(^DHCEMPCS(EmPcsID),"^",5)
		q $p(^DHCEMPCS(EmPcsID),"^",5)
}

/// 获取血氧饱合度SoP2
/// input:DHC_EmPatCheckLev rowid
ClassMethod getPatSoP2() As %String
{
		
		New (%EmPCLvID,%RetData)
		Set %RetData=0
		Set %EmPCLvID=$g(%EmPCLvID)
		Quit:%EmPCLvID="" 
		q:$f(%EmPCLvID,"^")>0 $p(%EmPCLvID,"^",2)
		
		s EmPcsID=""
	 	s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",%EmPCLvID,EmPcsID),-1)
		q:EmPcsID="" 
		s %RetData=$p(^DHCEMPCS(EmPcsID),"^",8)
		q $p(^DHCEMPCS(EmPcsID),"^",8)
}

/// 获取血压(BP)收缩压
/// input:DHC_EmPatCheckLev rowid
ClassMethod getPatSBP() As %String
{
		
		New (%EmPCLvID,%RetData)
		Set %RetData=0
		Set %EmPCLvID=$g(%EmPCLvID)
		Quit:%EmPCLvID=""
		q:$f(%EmPCLvID,"^")>0 $p(%EmPCLvID,"^",1)
		 
		s EmPcsID=""
	 	s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",%EmPCLvID,EmPcsID),-1)
		q:EmPcsID="" 
		s %RetData=$p(^DHCEMPCS(EmPcsID),"^",6)
		q $p(^DHCEMPCS(EmPcsID),"^",6)
}

/// 获取呼吸频率R
/// input:DHC_EmPatCheckLev rowid
ClassMethod getPatSR() As %String
{
		
		New (%EmPCLvID,%RetData)
		Set %RetData=0
		Set %EmPCLvID=$g(%EmPCLvID)
		Quit:%EmPCLvID=""
		q:$f(%EmPCLvID,"^")>0 $p(%EmPCLvID,"^",12)
		 
		s EmPcsID=""
	 	s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",%EmPCLvID,EmPcsID),-1)
		q:EmPcsID="" 
		s %RetData=$p(^DHCEMPCS(EmPcsID),"^",9)
		q $p(^DHCEMPCS(EmPcsID),"^",9)
}

/// 获取血压(BP)舒张压
/// input:DHC_EmPatCheckLev rowid
ClassMethod getPatDBP() As %String
{
		
		New (%EmPCLvID,%RetData)
		Set %RetData=0
		Set %EmPCLvID=$g(%EmPCLvID)
		Quit:%EmPCLvID="" 
		q:$f(%EmPCLvID,"^")>0 $p(%EmPCLvID,"^",9)
		
		s EmPcsID=""
	 	s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",%EmPCLvID,EmPcsID),-1)
		q:EmPcsID="" 
		s %RetData=$p(^DHCEMPCS(EmPcsID),"^",7)
		q $p(^DHCEMPCS(EmPcsID),"^",7)
}

/// 检查意识形态
/// input:DHC_EmPatCheckLev rowid
/// aware: 意识形态描述
/// return:1 符合条件 0 不符合条件
ClassMethod checkAware(aware = "") As %String
{
		
		New (%EmPCLvID,%RetData,aware)
		Set %RetData=0
		Set %EmPCLvID=$g(%EmPCLvID)
		Quit:%EmPCLvID=""
		q:($f(%EmPCLvID,"^")>0)&&(+$p(%EmPCLvID,"^",4)=0) 0
		q:$f(%EmPCLvID,"^")>0 $p(^DHCEMPAW($p(%EmPCLvID,"^",4)),"^",2)=aware
		
		s awid=+$p(^DHCEMPCL(%EmPCLvID),"^",17)
		q:awid=0 1
		
		s enable=$p(^DHCEMPAW(awid),"^",3)
		s aw=$p(^DHCEMPAW(awid),"^",2)
		
		q:enable'="Y" 1
		
		q:aw[aware 1
		
		q 0
}

/// 检查既往史
/// input:DHC_EmPatCheckLev rowid
/// hia: 既往史描述
/// return:1 符合条件 0 不符合条件
/// w ##class(web.DHCEMCalPatLevel).checkPatHis("")
ClassMethod checkPatHis(his = "") As %String
{
		
		New (%EmPCLvID,%RetData,his)
		Set %RetData=0
		Set %EmPCLvID=$g(%EmPCLvID)
		Quit:%EmPCLvID=""
		s ret=0
		i $f(%EmPCLvID,"^")>0 d
		.s hisstr=$p(%EmPCLvID,"^",5)
		.s hisstrlen=$l(hisstr,"$$")
		.f i=1:1:hisstrlen d
		..q:+$p(hisstr,"$$",i)=0
		..s hisdesc=$p(^DHCEMPHI($p(hisstr,"$$",i)),"^",2)
		..s:hisdesc=his ret=1
		
		q:$f(%EmPCLvID,"^")>0 ret
		
		s chkid=""
		
		f  s chkid=$o(^DHCEMPCH(0,"PatCheckLev",%EmPCLvID,chkid)) q:(chkid="")||(ret'=0)  d
		.s hisdr=$p(^DHCEMPCH(chkid),"^",2)
		.q:+hisdr=0
		.s hisflag=$p(^DHCEMPHI(hisdr),"^",3)	
		.q:hisflag'="Y"
		.s hisdesc=$p(^DHCEMPHI(hisdr),"^",2)
		.s:hisdr=his ret=1
		

		q ret
}

/// 计算休克指数
/// input:DHC_EmPatCheckLev rowid
/// return:休克指数
ClassMethod calXiuKe() As %String
{
		
		New (%EmPCLvID,%RetData,flag,his)
		Set %RetData=0
		Set %EmPCLvID=$g(%EmPCLvID)
		Quit:%EmPCLvID=""
		
		s hr=..getPatHR()
		s sbp=..getPatSBP()
		q:+sbp=0 0
		q:+hr=0 0
		q hr/sbp
}

/// 疼痛分级
/// input:DHC_EmPatCheckLev rowid 
ClassMethod getPain() As %String
{
		
		New (%EmPCLvID,symDesc)
		Set %EmPCLvID=$g(%EmPCLvID)
		s flag=0
		Quit:%EmPCLvID="" flag
		q:$f(%EmPCLvID,"^")>0 $p(%EmPCLvID,"^",8)
		q +$p(^DHCEMPCL(%EmPCLvID),"^",30)
}

/// 症状
/// input:DHC_EmPatCheckLev rowid / 者症状id
/// return:1 符合条件 0 不符合条件
ClassMethod checkSym(sym) As %String
{
		
		New (%EmPCLvID,sym)
		Set %EmPCLvID=$g(%EmPCLvID)
		s flag=0
		Quit:%EmPCLvID="" flag
		
		i $f(%EmPCLvID,"^")>0 d
		.s symStr=$p(%EmPCLvID,"^",7)
		.s tmpLen=$l(symStr,"$$")
		.f i=1:1:tmpLen d
		..q:$p(symStr,"$$",i)=""
		..s symItmDesc=$p(symStr,"$$",i)
		..s:symItmDesc=sym flag=1
		..i symItmDesc[":" d	;针对含有父节点描述
		...s:$p(symItmDesc,":",2)=sym flag=1
		
		q:$f(%EmPCLvID,"^")>0 flag
		
		s EmSymDesc=$p(^DHCEMPCL(%EmPCLvID),"^",25) 	    /// 症状
		s symLen=$l(EmSymDesc,"#")
		f i=1:1:symLen d
		.s tmpStr=$p(EmSymDesc,"#",i)
		.s tmpId=$p(tmpStr,"!",1)
		.s:sym=tmpId flag=1
		
		q flag
}

/// 父症状
/// input:DHC_EmPatCheckLev rowid / 者症状id
/// return:1 符合条件 0 不符合条件
/// w ##class(web.DHCEMCalPatLevel).checkParSym("腹痛")
ClassMethod checkParSym(sym) As %String
{
		
		New (%EmPCLvID,sym)
		Set %EmPCLvID=$g(%EmPCLvID)
		s flag=0
		
		Quit:%EmPCLvID="" flag
		
		i $f(%EmPCLvID,"^")>0 d
		.s symStr=$p(%EmPCLvID,"^",7)
		.s tmpLen=$l(symStr,"$$")
		.f i=1:1:tmpLen d
		..q:$p(symStr,"$$",i)=""
		..s:$p($p(symStr,"$$",i),":",1)=sym flag=1
		
		q:$f(%EmPCLvID,"^")>0 flag

		s EmSymDesc=$p(^DHCEMPCL(%EmPCLvID),"^",25) 	    /// 症状
		s symLen=$l(EmSymDesc,"#")
		f i=1:1:symLen d
		.s tmpStr=$p(EmSymDesc,"#",i)
		.s tmpId=$p(tmpStr,"!",1)
		.s:sym=tmpId flag=1
		
		q flag
}

/// 年龄
/// input:DHC_EmPatCheckLev rowid 
ClassMethod getAge() As %String
{
		
		New (%EmPCLvID,symDesc)
		Set %EmPCLvID=$g(%EmPCLvID)
		s age=0
		i $f(%EmPCLvID,"^")>0 d
		.s age=$p(%EmPCLvID,"^",11)
		.s:$f(age,"小时")>0 age=age/365*24
		.s:$f(age,"天")>0 age=age/365
		.s:$f(age,"月")>0 age=age/12
		q age
}

/// 年龄
/// input:DHC_EmPatCheckLev rowid 
ClassMethod getAgeD() As %String
{
		
		New (%EmPCLvID,symDesc)
		Set %EmPCLvID=$g(%EmPCLvID)
		s age=0
		i $f(%EmPCLvID,"^")>0 d
		.s age=$p(%EmPCLvID,"^",11)
		.s:$f(age,"小时")>0 age=age\(24)
		.s:$f(age,"天")>0 age=age
		.s:$f(age,"月")>0 age=age*30
		.s:$f(age,"岁")>0 age=age*12
		q age
}

/// 年龄
/// input:DHC_EmPatCheckLev rowid 
ClassMethod getAgeM() As %String
{
		
		New (%EmPCLvID,symDesc)
		Set %EmPCLvID=$g(%EmPCLvID)
		s age=0
		i $f(%EmPCLvID,"^")>0 d
		.s age=$p(%EmPCLvID,"^",11)
		.s:$f(age,"小时")>0 age=age\(24*30)
		.s:$f(age,"天")>0 age=age\30
		.s:$f(age,"月")>0 age=age
		.s:$f(age,"岁")>0 age=age*12
		q age
}

/// 年龄
/// input:DHC_EmPatCheckLev rowid 
ClassMethod getAgeY() As %String
{
		
		New (%EmPCLvID,symDesc)
		Set %EmPCLvID=$g(%EmPCLvID)
		s age=0
		i $f(%EmPCLvID,"^")>0 d
		.s age=$p(%EmPCLvID,"^",11)
		.s:$f(age,"小时")>0 age=age\(24*30*365)
		.s:$f(age,"天")>0 age=age\(30*365)
		.s:$f(age,"月")>0 age=age\12
		.s:$f(age,"年")>0 age=age
		q age
}

/// 呼吸频率
/// input:DHC_EmPatCheckLev rowid 
ClassMethod getBreath() As %String
{
		
		New (%EmPCLvID,symDesc)
		Set %EmPCLvID=$g(%EmPCLvID)
		s breath=0
		i $f(%EmPCLvID,"^")>0 d
		.s breath=$p(%EmPCLvID,"^",12)
		q breath
}

/// 哥斯拉得分
/// input:DHC_EmPatCheckLev rowid
/// w ##class(web.DHCEMCalPatLevel).getGCS() 
ClassMethod getGCS() As %String
{
		
		New (%EmPCLvID,symDesc)
		Set %EmPCLvID=$g(%EmPCLvID)
		s ret=0
		i $f(%EmPCLvID,"^")>0 d
		.s gcs=$p(%EmPCLvID,"^",13)
		.f i=1:1:$l(gcs,"#") d
		..s gcsitm=$p(gcs,"#",i)
		..q:+gcsitm=0
		..s ret=ret+$p(^DHCEMGCS(+gcsitm,"I",$p(gcsitm,"||",2)),"^",5)
		q ret
}

}
