Import sqluser

/// Descript:   检查医嘱项注意事项表
/// Creator:    bianshuai
/// CreateDate: 2016-04-11
Class web.DHCAPPArcNote Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	检查医嘱项注意事项表
/// w ##class(web.DHCAPPArcNote).saveArcNote("^11207||1^6")
ClassMethod saveArcNote(anArcNoteDataList As %String) As %String
{
	n (anArcNoteDataList)
	s Len=$L(anArcNoteDataList,"$$")
	s Err=0
	f i=1:1:Len q:Err'=0  d
	.s anArcNoteStr=$p(anArcNoteDataList,"$$",i)
	.s itmmastid=$p(anArcNoteStr,"^",2)  ///医嘱项ID
	.s itmTempID=$p(anArcNoteStr,"^",3)  ///注意事项ID
	.s Err=##class(web.DHCAPPArcNote).isExistSameItem(itmmastid, itmTempID) /// 重复性判断
	.Q:Err'=0
	.i $p(anArcNoteStr,"^",1) ="" d
	..s Err=..insArcNote(anArcNoteStr)
	.e  d
	..s Err=..updArcNote(anArcNoteStr)
	q Err
}

/// Descript:	增加 检查医嘱项注意事项表
/// w ##class(web.DHCAPPArcNote).insArcNote("")
ClassMethod insArcNote(anArcNoteStr As %String) As %String
{
	n (anArcNoteStr)
	s anArcID=$p(anArcNoteStr,"^",2)   		///医嘱项ID
	s anTempID=$p(anArcNoteStr,"^",3)   	///注意事项ID
 	&SQL(INSERT INTO DHC_AppArcNote(AC_Arc_Dr,AC_Temp_Dr) VALUES(:anArcID,:anTempID))
 	q SQLCODE
}

/// Descript:	更新 检查医嘱项注意事项表
/// w ##class(web.DHCAPPArcNote).updArcNote("")
ClassMethod updArcNote(anArcNoteStr As %String) As %String
{
	n (anArcNoteStr)
	s anID=$p(anArcNoteStr,"^",1)   	///ID
	s anArcID=$p(anArcNoteStr,"^",2)   	///医嘱项ID
	s anTempID=$p(anArcNoteStr,"^",3)   ///注意事项ID
	&SQL(Update DHC_AppArcNote Set AC_Arc_Dr=:anArcID, AC_Temp_Dr=:anTempID WHERE AC_RowID=:anID)
 	q SQLCODE
}

/// Descript:	删除 检查医嘱项注意事项表
/// w ##class(web.DHCAPPArcNote).delArcNote("1")
ClassMethod delArcNote(anID As %String) As %String
{
	N (anID)
	&SQL(Delete From DHC_AppArcNote Where AC_RowID=:anID)
	Q SQLCODE
}

/// Descript:查询[注意事项模板字典]
/// w ##class(web.DHCAPPArcNote).QueryAppArcNote("12","1","233||1")
ClassMethod QueryAppArcNote(rows As %String, page As %String, itmmastid As %String, HospID As %String) As %String
{
	N (rows,page,itmmastid,HospID)
	s End = page*rows
	s Start=(page-1)*rows+1
	
    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s h=0,count=0
	s ID=""
	f  s ID=$o(^DHCAPARCNO(0,"ARC",itmmastid,ID)) q:ID=""  d
	.s itmmast=$p(^DHCAPARCNO(ID),"^",1)   		 //医嘱项ID
	.s itemTempId=$p(^DHCAPARCNO(ID),"^",2)      		 //注意事项ID
	.s itemHospID=$p(^DHCAPITMTE(itemTempId),"^",4)      //医院ID
	.Q:(HospID'="")&(itemHospID'=HospID)
	.s itemTempDesc=$p(^DHCAPITMTE(itemTempId),"^",2)    //描述
	.s h=h+1
	.s ListData=ID_"^"_itmmast_"^"_itemTempId_"^"_itemTempDesc
	.s ^TMP("DHCST","web.DHCAPPArcNote","QueryAppArcNote",pid,h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ID^itmmast^itemTempId^itemTempDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPArcNote","QueryAppArcNote",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPArcNote","QueryAppArcNote",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// w ##class(web.DHCAPPArcNote).GetAppArcNote("4363||1")
ClassMethod GetAppArcNote(itmmastid As %String, HospID As %String) As %String
{
	N (itmmastid,HospID)
	s ID=""
	s Str=""
	f  s ID=$o(^DHCAPARCNO(0,"ARC",itmmastid,ID)) q:ID=""  d
	.s itmmast=$p(^DHCAPARCNO(ID),"^",1)   		 //医嘱项ID
	.s itemTempId=$p(^DHCAPARCNO(ID),"^",2)      		 //注意事项ID
	.s itemHospID=$p(^DHCAPITMTE(itemTempId),"^",4)      //医院ID
	.Q:(HospID'="")&(itemHospID'=HospID)
	.s subid=""
	.f  s subid=$O(^DHCAPITMTE(itemTempId,"D",subid)) q:subid=""  d
	..s substr=$G(^DHCAPITMTE(itemTempId,"D",subid))
	..s substr=$replace(substr,"<br>","")
	..s Str=Str_substr
	q Str
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCAPPArcNote","QueryAppArcNote",pid)
}

/// Descript:检查是否存在相同项目
/// w ##class(web.DHCAPPArcNote).isExistSameItem("12996||1","1")
ClassMethod isExistSameItem(itmmastid As %String, itmTempID As %String) As %String
{
	n (itmmastid, itmTempID)
	s quitflag=0
	s ID=""
	f  s ID=$o(^DHCAPARCNO(0,"ARC",itmmastid,ID)) Q:(ID="")||(quitflag=1)  D
	.s TempID=$p(^DHCAPARCNO(ID),"^",2)
	.Q:TempID'=itmTempID
	.s quitflag=1
	Q quitflag
}

}
