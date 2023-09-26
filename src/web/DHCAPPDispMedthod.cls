Import SQLUSER

Class web.DHCAPPDispMedthod Extends %Library.RegisteredObject [ ClassType = "", NoExtent, Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2016-4-11
/// Description:： 查询后处理方法表
/// Table：        DHC_AppDispMedthod 
/// Others：       w ##class(web.DHCAPPDispMedthod).QueryMedthod("11","1","")
ClassMethod QueryMedthod(rows As %String, page As %String, params As %String, HospID) As %String
{
	n (rows,page,params,HospID)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)      //k掉临时global
	s code=$p(params,"^",1)     //在串params中取值
	s desc=$p(params,"^",2)
	s h=0,count=0
	s adrowid=""
	f  s adrowid=$o(^DHCAPDIM(adrowid)) q:adrowid=""  d  //查询表DHC_AppDispMedthod
	.q:adrowid=0
	.s adcode=$p(^DHCAPDIM(adrowid),"^",1)
	.s addesc=$p(^DHCAPDIM(adrowid),"^",2)
	.s adactiveflag=$p(^DHCAPDIM(adrowid),"^",3)
	.s adactiveflag=$s(adactiveflag="Y":"是",adactiveflag="N":"否",1:"")
	.s adhospdr=+$p(^DHCAPDIM(adrowid),"^",4)
	.q:((HospID'="")&&(adhospdr'=HospID))
	.s hospdesc=""
	.i adhospdr'=0 d
	..s hospdesc=$p(^CT("HOSP",adhospdr),"^",2)
	.q:(code'="")&(adcode'[code)      //判断
	.q:(desc'="")&(addesc'[desc)
	.s h=h+1
	.s tempstr=adrowid_"^"_adcode_"^"_addesc_"^"_adactiveflag_"^"_hospdesc_"^"_adhospdr
	.s ^TMP("DHCST","web.DHCAPPDispMedthod","QueryMedthod",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="adrowid^adcode^addesc^adactiveflag^hospdesc^adhospdr"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPDispMedthod","QueryMedthod",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCAPPDispMedthod","QueryMedthod",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2016-4-11
/// Description:： 保存表中数据
/// Table：        DHC_AppDispMedthod 
ClassMethod SaveMedthod(params As %String) As %String
{
  	n (params)
  	s ret=0
	s len=$L(params,"&&")
	f i=1:1:len q:ret'=0  d
	.s tmpstr=$p(params,"&&",i)
	.i $p(tmpstr,"^",1)'="" d
	..s ret=..UpdMedthod(tmpstr)
	.e  d
	..s ret=..AddMedthod(tmpstr)
	q ret
}

/// Creator：      sufan
/// CreatDate：    2016-4-11
/// Description:： 增加后处理方法表
/// Table：        DHC_AppDispMedthod 
/// Others：       w ##class(web.DHCAPPDispMedthod).AddMedthod("^1^1^Y^2")
ClassMethod AddMedthod(params As %String) As %String
{
	n (params)
	s adcode=$p(params,"^",2)
	s adhospdr=$p(params,"^",5)
	q:$d(^DHCAPDIM(0,"Code",$$ALPHAUP^SSUTIL4(adcode),adhospdr)) -1
	s addesc=$p(params,"^",3)
	q:$d(^DHCAPDIM(0,"Desc",$$ALPHAUP^SSUTIL4(addesc),adhospdr)) -2
	s adactiveflag=$p(params,"^",4)

	;s hospdesc=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospdesc),""))  ///sufan  2017/1/6
	&sql(insert into DHC_AppDispMedthod (AD_Code,AD_Desc,AD_ActiveFlag,AD_Hosp_Dr)values (:adcode,:addesc,:adactiveflag,:adhospdr ))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-4-11
/// Description:： 更新后处理方法表
/// Table：        DHC_AppDispMedthod 
/// Others：       w ##class(web.DHCAPPDispMedthod).UpdMedthod("38^3^33^Y^2")
ClassMethod UpdMedthod(params As %String) As %String
{
  	n (params)
  	s adrowid=$p(params,"^",1)
  	s adhospdr=$p(params,"^",5)
  	s code=$p(^DHCAPDIM(adrowid),"^",1)
	s adcode=$p(params,"^",2)
	i adcode'=code  {
		s RepeatId=$o(^DHCAPDIM(0,"Code",$$ALPHAUP^SSUTIL4(adcode),adhospdr,""))
		q:(RepeatId'="")&&(RepeatId'=adrowid) -3
	}
	s desc=$p(^DHCAPDIM(adrowid),"^",1)
	s addesc=$p(params,"^",3)
	i addesc'=desc  {
		s RepeatId=$o(^DHCAPDIM(0,"Desc",$$ALPHAUP^SSUTIL4(addesc),adhospdr,""))
		q:(RepeatId'="")&&(RepeatId'=adrowid) -4
		//q:$d(^DHCAPDIM(0,"Desc",$$ALPHAUP^SSUTIL4(addesc),adhospdr)) -4
	}
	s adactiveflag=$p(params,"^",4)
	i adactiveflag="是" s adactiveflag="Y"
	i adactiveflag="否" s adactiveflag="N"
	&sql(update DHC_AppDispMedthod set AD_Code=:adcode,AD_Desc=:addesc,AD_ActiveFlag=:adactiveflag,AD_Hosp_Dr=:adhospdr where AD_RowID=:adrowid )
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-4-11
/// Description:： 删除后处理方法表信息
/// Table：        DHC_AppDispMedthod 
/// Others：       w ##class(web.DHCAPPDispMedthod).DelMedthod("1")
ClassMethod DelMedthod(params As %String) As %String
{
	n (params)
	q:($d(^DHCAPARCDI(0,"DispArc",params))||$d(^DHCAPREP(0,"Disp",params))) -11
  	&sql(delete from DHC_AppDispMedthod where AD_RowID=:params )
  	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-4-11
/// Description:： 查询医院描述
/// Table：        CT_Hospital 
/// Others：       w ##class(web.DHCAPPDispMedthod).SelHosp()
ClassMethod SelHosp() As %String
{
    w ##Class(web.DHCAPPCommonUtil).GetHospDs()  //liangqiang
}

ClassMethod GetCode() As %String
{
	;w ##class(web.DHCAPPDispMedthod).GetCode()
	s rowid=""
	f  s rowid=$o(^DHCAPDIM(rowid)) q:rowid=""  d
	.q:rowid=0
	.s code=$p(^DHCAPDIM(rowid),"^",1)
	.w !,code
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCST","web.DHCAPPDispMedthod","QueryMedthod",pid)
}

}
