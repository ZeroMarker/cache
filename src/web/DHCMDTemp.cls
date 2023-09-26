Import SQLUser

Class web.DHCMDTemp Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		mdt会诊模板
/// w ##class(web.DHCMDTemp).save("^1^asd^ada"")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
	s ^tempyzyy("32")=$lb(mParam)
	s Err=0 
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		增加
/// w ##class(web.DHCMDTemp).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s ^tempyyz("212")=$lb(mParam)
	s Title=$p(mParam,"^",3)   	/// 标题
	s Text=$p(mParam,"^",4)   	/// 内容
	;s Type=$p(mParam,"^",4)   	/// 类型
	s Pointer=$p(mParam,"^",2)  /// 指针
 	&SQL(INSERT INTO DHC_MDTOpiTemp(MT_Title, MT_Text, MT_Pointer) VALUES(:Title,:Text,:Pointer))
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		更新
/// w ##class(web.DHCMDTemp).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Title=$p(mParam,"^",3)   	/// 标题
	s Text=$p(mParam,"^",4)   	/// 内容
	;s Type=$p(mParam,"^",4)   	/// 类型
	s Pointer=$p(mParam,"^",2)  /// 指针
	&SQL(Update DHC_MDTOpiTemp Set MT_Title=:Title, MT_Text=:Text,MT_Pointer=:Pointer WHERE MT_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		删除
/// w ##class(web.DHCMDTemp).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTOpiTemp Where MT_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-10
/// Descript:		查询
/// w ##class(web.DHCMDTemp).QryOpiTemp("12","1","2")
ClassMethod QryOpiTemp(rows As %String, page As %String, mID As %String) As %String
{
	N (rows, page, mID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	
	s ID="0"
	F  s ID=$o(^DHCMDTOT(0,"pointer",mID,ID)) Q:ID=""  D
	.s Title=$p(^DHCMDTOT(ID),"^",1)    /// 标题
	.s Text=$p(^DHCMDTOT(ID),"^",2)     /// 描述
	.;s Type=$p(^DHCMDTOT(ID),"^",3)     /// 类型
	.s Pointer=$p(^DHCMDTOT(ID),"^",4)  /// 指针
	.s h=h+1
	.s ListData=ID_"^"_Pointer_"^"_Title_"^"_Text
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Pointer^Title^Text"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	F  s index=$o(TmpItemDet(index)) Q:index=""  D
	.s ListData=$g(TmpItemDet(index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符

	Q ""
}

/// Creator: 		lvpeng
/// CreateDate: 	2021-04-21
/// Descript:		保存会议模板
/// Input:
/// w ##class(web.DHCMDTemp).savemeettemp("80","physical:查体^treatment:诊疗经过^labexamination:实验室检查^imageexam:影像学^clinicaldiag:头晕和眩晕111^cstpurpose:会诊目的")
ClassMethod savemeettemp(formId As %String, par As %String) As %String
{
	n (formId,par)
	
	s code=0
	ts
	
	s id=""
	f  s id=$o(^User.DHCMDTMeetTempI("IndexMdtRecord",formId,id)) q:id=""  d
	.&sql(delete from DHC_MDTMeetTemp where ID=:id)	
	
	s len=$l(par,"^")	
	f i=1:1:len d
	.s ret=##class(web.DHCMDTemp).SaveRecord($p(par,"^",i),formId)
	.i ret'=0 s code=ret
	i code'=0 tro
	q:code'=0 code
	
	tc
	
	q code
}

/// Descript:	保存表单记录
/// Creator:	lvpeng
/// Table:		DHC_MDTMeetTemp
ClassMethod SaveRecord(str = "", formId = "")
{
	n (str,formId)
	s $ze="Err",ret=0
	
	q:str="" 0
	s row=""
 	s code=$p(str,":",1)

 	s strLen=$l(str)
 	s codeLen=$l(code)+2
 	s value=$e(str,codeLen,strLen)
 	
 	q:code="" 0
 	
	//s typeId=+$o(^DHCPUEEMRTYPE(0,"TypeCode",type,code,""))	
	//q:typeId=0 0
	//只是界面显示字段，不保存
	//q:$p(^DHCPUEEMRTYPE(typeId),"^",7)'="Y" 0
	 
	s key=$p(str,":",1)
	s strL=$l(str) ;hxy 2017-11-29 st 文本框中有“:/”时，保存后，“:/”及后面的信息不显示
	s keyL=$l(key)
	S value=$Extract(str,keyL+2,strL) 
	
	s itmObj=##class(User.DHCMDTMeetTemp).%New()
	d itmObj.MMParRefDrSetObjectId(formId)
	s itmObj.MMItemVal=value
	s itmObj.MMItemCode=key
	s sc=itmObj.%Save()
	If $$$ISERR(sc) d
	.s ret=$System.Status.GetErrorText(sc)
	
	q:ret'=0 "["_$case(key,"physical":"查体","treatment":"诊疗经过","labexamination":"实验室检查","imageexam":"影像学",
		"clinicaldiag":"临床诊断","cstpurpose":"会诊目的")_"]超过最大字符限制1000字!"
	
 	q ret
Err
  q -1
}

/// Creator：      lvpeng
/// CreatDate：    2021-04-22
/// Description:： 查询会议模板
/// Table：        DHC_MDTMeetTemp
/// Input:         type:表单类型
///                adm:就诊记录   
/// Others：       w ##class(web.DHCMDTemp).findByEmrId("124")
ClassMethod findByEmrId(mdtID)
{
	
	n (mdtID)

	q:mdtID=0 "[]"
	
	s id="",rowData="",i=0,titlestr=""
	f  s id=$o(^User.DHCMDTMeetTempI("IndexMdtRecord",mdtID,id)) q:id=""  d
	.s code=$lg(^User.DHCMDTMeetTempD(id),3)
	.s value=$lg(^User.DHCMDTMeetTempD(id),4)	
	.s i=i+1
	.s $p(rowData,"^",i)=$g(value)
	.s $p(titlestr,"^",i)=code
	
	w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,rowData)
	q ""
}

}
