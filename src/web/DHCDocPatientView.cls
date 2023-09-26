Class web.DHCDocPatientView Extends %RegisteredObject
{

/// w ##class(web.DHCDocPatientView).GetColumnsJson("web.DHCDocMain","FindCurrentAdmProxy")
ClassMethod GetColumnsJson(ClassName As %String, QueryName As %String)
{
	s colmunStr=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQOutParaList(ClassName,QueryName,"")
	s ColumStr=""
	s len=$l(colmunStr,",")
	k MyColTempList
	s context="K"_ClassName_":"_QueryName
	s uSet=""
	s userid=""
	if ($g(%session)'="")&&($g(%session.Data("LOGON.USERID"))'="") d
	.s uSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")))
	.//s uSet=##Class(websys.Preferences).GetDataExLE(3475,29,65,"DHCHEALTH",context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,"","")
	.i activecontext'=context set uSet="" ;查询出的不是放大镜的列布局
	.i uSet=",," Set uSet=""
	.;不能改顺序,影响前台取值
	.f idx=1:1:$l(uSet,"|") d
	..s uSetItem = $p(uSet,"|",idx)
	..s myIdx = $p(uSetItem,",",1)		;col-index,width,sort|
	..s:myIdx>0 hiddenPlist(myIdx)=1,hiddenPlist(myIdx,2)=$p(uSetItem,",",2),hiddenPlist(myIdx,3)=$p(uSetItem,",",3)
	
	for i=1:1:len{
		s onecolmunStr=$p(colmunStr,",",i)	
		s Name=$p(onecolmunStr,":",1)
		s Title=$p(onecolmunStr,":",3)
		s width=100
		if +$p(Title,"^",2)>0{
			s width=$p(Title,"^",2)	
		}
		s Title=$p(Title,"^",1)
		if Title="" Set Hidden="true"
		else  Set Hidden="false"
		i (uSet'=""),$g(hiddenPlist(i))="" s Hidden="true"
		
		s MyColTempList(i)=Name_$c(1)_Title_$c(1)_Hidden_$c(1)_width
		
		//s str="{"_"field:"_""""_Name_""""_","_"title:"_""""_Title_""""_","_"width:100,"_"hidden:"_Hidden_",align:"_""""_"center"_""""_"}"
		//if ColumStr="" Set ColumStr=str
		//else  Set ColumStr=ColumStr_","_str 
	}
	b ;5454
	k MyColTempListNew
	s indexNum=0
	i uSet'="" d
	.f idx=1:1:$l(uSet,"|") d
	..s uSetItem = $p(uSet,"|",idx)
	..s myIdx = $p(uSetItem,",",1)		; col-index,width,sort|
	..q:+myIdx=0
	..q:myIdx>len	;如果保存列编辑后,query出参列减少
	..s indexNum=indexNum+1
	..s MyColTempListNew(indexNum)=MyColTempList(myIdx)
	..k MyColTempList(myIdx)
	
	s idx=0
	for  s idx=$o(MyColTempList(idx)) Quit:idx=""  do
	.s indexNum=indexNum+1
	.s MyColTempListNew(indexNum)=MyColTempList(idx)
	
	b ;5445
	s idx=0
	for  s idx=$o(MyColTempListNew(idx)) Quit:idx=""  do
	.s ColStr=MyColTempListNew(idx)
	.s Name=$p(ColStr,$c(1),1)
	.s Title=$p(ColStr,$c(1),2)
	.s Hidden=$p(ColStr,$c(1),3)
	.s width=$p(ColStr,$c(1),4)
	.s str="{"_"field:"_""""_Name_""""_","_"title:"_""""_Title_""""_","_"width:"_width_","_"hidden:"_Hidden_",align:"_""""_"center"_""""_"}"
	.if ColumStr="" Set ColumStr=str
	.else  Set ColumStr=ColumStr_","_str 
	
	
	
	Set JsonStr="[["_ColumStr_"]]"
	Quit JsonStr
}

}
