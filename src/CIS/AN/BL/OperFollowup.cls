/// 术后随访业务类
Class CIS.AN.BL.OperFollowup Extends %RegisteredObject
{

/// Creator：        王枭啸
/// CreatDate：      2020-10-28
/// Description：    查询病人术后随访
/// Table：          CIS_AN.OperFollowup
/// Input:           opsId:病人手术申请id
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperFollowup","FindFollowupList",156)
Query FindFollowupList(opsId As %String) As %Query(ROWSPEC = "RowId,DateTime,No,Type,User,Status,MouldId") [ SqlProc ]
{
}

ClassMethod FindFollowupListExecute(ByRef qHandle As %Binary, opsId As %String) As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    
    q:opsId="" "手术id为空！"
    s rowId=""
    f  s rowId=$o(^CIS.AN.OperFollowupI("ISchedule",opsId,rowId)) q:rowId=""  d
    .s No=$list(^CIS.AN.OperFollowupD(rowId),2)
    .s date=$list(^CIS.AN.OperFollowupD(rowId),3)
    .s time=$list(^CIS.AN.OperFollowupD(rowId),4)
    .;i (date'="")&&(time'="") s DateTime=$zd(date,3)_" "_$zt(time)
    .i (date'="")&&(time'="") s DateTime=..ConvertToDate(date,"")_" "_$zt(time)
    .s MouldId=$list(^CIS.AN.OperFollowupD(rowId),5)
    .q:MouldId=""
    .s Type=$list(^CIS.AN.OperFollowupMouldD(MouldId),2)
    .s userId=$list(^CIS.AN.OperFollowupD(rowId),6)
    .i userId'="" s User=##class(CIS.AN.BL.Admission).GetUserTypeName(userId)
    .s stat=$list(^CIS.AN.OperFollowupD(rowId),7)
    .;q:stat="D"
	.i stat="E" s Status="未完成"
	.i stat="F" s Status="完成"
	.d OutputRow
    
    
    
    s qHandle=$lb(0,repid,0)
    q $$$OK 
OutputRow
    s Data=$lb(rowId,DateTime,No,Type,$p(User,"^",2),Status,MouldId)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod FindFollowupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFollowupListExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod FindFollowupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFollowupListExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod ConvertToDate(dateVal As %String, defaultStr As %String = "$H") As %String
{
	s dateformatnum=##class(websys.Conversions).DateFormat()
	q:((+dateVal=0)!(dateVal<0)!(dateVal>2980013))&(defaultStr="") ""
	q:(+dateVal=0)!(dateVal<0)!(dateVal>2980013) $zd($h,dateformatnum)
	q $zd(dateVal,dateformatnum)
}

/// 新增随访记录
/// w ##Class(CIS.AN.BL.OperFollowup).AddFollowupList("101","10211")
ClassMethod AddFollowupList(opsId As %String, userId As %String, no As %String, date As %String, time As %String, mouldId As %String) As %String
{
	q:opsId="" ""
	q:no="" "请选择随访次数！"
	q:date="" "请选择随访日期！"
	q:time="" "请选择随访时间！"
	q:mouldId="" "请选择模板！"
	s ret=0
	s rowId=""
    f  s rowId=$o(^CIS.AN.OperFollowupI("ISchedule",opsId,rowId)) q:rowId=""  d
    .s No=$list(^CIS.AN.OperFollowupD(rowId),2)
    .i No=no s ret="-1"
    q:ret="-1" "该次数已存在!"
	s date=##class(CIS.AN.COM.DateTime).ConvertToDateH(date),time=##class(CIS.AN.COM.DateTime).ConvertToTimeH(time)
	&sql(insert into CIS_AN.OperFollowup (OperSchedule,FollowupNo,FollowupDate,FollowupTime,UserId,Status,Type) values (:opsId,:no,:date,:time,:userId,"E",:mouldId))
	q SQLCODE
}

/// 删除随访记录
/// w ##Class(CIS.AN.BL.OperFollowup).DeleteFollowupList(3)
ClassMethod DeleteFollowupList(rowId As %String) As %String
{
	&sql(delete CIS_AN.OperFollowup where RowId=:rowId)
	
	q SQLCODE
}

/// 新增随访记录
/// w ##Class(CIS.AN.BL.OperFollowup).SaveFollowupDetails(2,^wxx("SaveFollowupDetails"))
ClassMethod SaveFollowupDetails(RowId As %String, data As %String) As %String
{
	s ^wxx("SaveFollowupDetails")=data
	set saveResult=""
    tstart
    set status=##class(CIS.AN.COM.String).ToArray(data,.array)
    set objIndex=0
    for
    {
        set objIndex=$order(array(objIndex))
        quit:(objIndex="")
        k singleData
        set popNode="",singleData=""
        for 
        {
            set popNode=$order(array(objIndex,popNode))
            quit:(popNode="")
            
            set singleData(popNode)=array(objIndex,popNode)
        }
        set singleData("FollowupSheet")=RowId
        ;b //1
        set saveResult=##class(CIS.AN.COM.DataService).SaveData(.singleData)
        quit:($piece(saveResult,"^",1)="E")
    }
    if ($piece(saveResult,"^",1)="E")
    {
        trollback
        quit saveResult 
    }
    tcommit 
    b //2
    quit 0
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperFollowup","FindFollowupDetails",3)
Query FindFollowupDetails(RowId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   FollowupSheet,
	   DataItem,
	   DataValue,
	   %ODBCOUT(ExecDate) As ExecDate,
	   %ODBCOUT(ExecTime) As ExecTime,
	   %ODBCOUT(ExecDate)+' '+%ODBCOUT(ExecTime) As ExecDT,
	   UpdateUserID,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUserID) As UpdateUserDesc,
	   DataScore,
	   DataNote
	   from CIS_AN.OperFollowupDetails 
	   where FollowupSheet=:RowId
}

/// 随访记录置完成状态
/// w ##Class(CIS.AN.BL.OperFollowup).FinishFollowupDetails(3)
ClassMethod FinishFollowupDetails(rowId As %String) As %String
{
	&sql(update CIS_AN.OperFollowup set Status="F" where RowId=:rowId)
	q SQLCODE
}

/// 获取术后随访标志
/// return:有一条已完成的术后随访记录返回Y，其他返回N
/// w ##Class(CIS.AN.BL.OperFollowup).GetFollowupFlag(156)
ClassMethod GetFollowupFlag(opsId As %String) As %String
{
	q:opsId="" "手术id为空！"
	s flag="N"
    s rowId=""
    f  s rowId=$o(^CIS.AN.OperFollowupI("ISchedule",opsId,rowId)) q:rowId=""  d
    .s stat=$list(^CIS.AN.OperFollowupD(rowId),7)
	.i stat="F" s flag="Y"
	
	q flag
}

/// Description：    查询术后随访模板
/// Table：          CIS_AN.OperFollowupMould
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperFollowup","FindFollowupMould")
Query FindFollowupMould() As %SQLQuery(CONTAINID = 1)
{
SELECT %Id As RowId,
       MouldCode As Code,
       MouldDesc As Description 
       from SQLUser.CIS_AN.OperFollowupMould
}

/// 获取模板明细
/// w ##Class(CIS.AN.BL.OperFollowup).GetFollowupMouldDetails(1)
ClassMethod GetFollowupMouldDetails(MouldId As %String) As %String
{
	q:MouldId="" "模板id为空！"
	s ret=""
	s ret=$list(^CIS.AN.OperFollowupMouldD(MouldId),3)
	
	q ret
}

/// 保存模板明细
/// w ##Class(CIS.AN.BL.OperFollowup).SaveFollowupMouldDetails("DaySurgeryTemp","日间术后模板","备注^textbox#BZ^N")
ClassMethod SaveFollowupMouldDetails(code As %String, desc As %String, values As %String) As %String
{
	q:code="" "模板代码为空！"
	q:desc="" "模板描述为空！"
	s rowId=""
	s MouldId=""
	f  s MouldId=$o(^CIS.AN.OperFollowupMouldD(MouldId)) q:MouldId=""  d
	.s Mouldcode=$list(^CIS.AN.OperFollowupMouldD(MouldId),1)
	.i Mouldcode=code s rowId=MouldId   //代码相同时则更新
	s nameLStr=""
	//获取每个panel的名称长度(最长的一项长度)
	f iL=1:1:$length(values,";") d
		.s maxL=0
		.s strPanel=$p(values,";",iL)
		.f nL=1:1:$length(strPanel,",") d
		..s strElement=$p(strPanel,",",nL)
		..s strname=$p(strElement,"^",1)    //元素名称
		..s strtype=$p(strElement,"^",2)    //元素类型
		..s requiredFlag=$p(strElement,"^",3)   //是否必填
		..q:strtype["title"
	    ..s nameL=$length(strname)   //名称长度
	    ..i requiredFlag="Y" s nameL=nameL+1
	    ..i nameL>maxL s maxL=nameL
	    .i nameLStr="" s nameLStr=maxL
	    .e  s nameLStr=nameLStr_"^"_maxL
   
	//格式转换
	s valueStr=""
	f i=1:1:$length(values,";") d
	.s strPanel=$p(values,";",i)
	.s nameL=$p(nameLStr,"^",i)   //名称长度
	.s pIndex=0
	.f n=1:1:$length(strPanel,",") d
	..s pIndex=pIndex+1
	..s strElement=$p(strPanel,",",n)
	..s strname=$p(strElement,"^",1)    //元素名称
	..s strtype=$p(strElement,"^",2)    //元素类型
	..s strCode=$p(strtype,"#",2)
	..s requiredFlag=$p(strElement,"^",3)   //是否必填
	..;w !,strname_"^"_strtype_"^"_strCode_"^"_requiredFlag
	..i strtype["title" d
	...s valueStr=valueStr_"<table style=""width:100%;""><thead><tr><th style=""background-color:#f5f6f5"">"_strname_"</th></tr></thead><tbody><tr><td>"
	..i strtype["combobox" d
	...s multipleFlag=$p(strElement,"^",4)  //是否可多选
	...s selectStr=$p(strtype,"#",3)
	...i requiredFlag="Y" d
	....s valueStr=valueStr_"<div class=""form-row""><div class=""form-title-right"_nameL_"""><span style=""color:red"">*</span>"_strname_"</div><div class=""form-item"" style=""width:300px;margin-left:-5px;"">"
	...e  s valueStr=valueStr_"<div class=""form-row""><div class=""form-title-right"_nameL_""">"_strname_"</div><div class=""form-item"" style=""width:300px;margin-left:-5px;"">"
	...s index=0
	...f l=1:1:$length(selectStr,"&")  d
	....s index=index+1
	....s selectName=$p(selectStr,"&",l)
	....s selectId=strCode_index
	....s valueStr=valueStr_"<input type=""checkbox"" id="""_selectId_""" data-formitem="""_strCode_""" class=""hisui-checkbox"" label="""_selectName_""">"
	....i index=$length(selectStr,"&") d
	.....s valueStr=valueStr_"<input type=""hidden"" id="""_strCode_""" data-title="""_strname_""" class=""operdata"" data-multiple="""_multipleFlag_""" data-required="""_requiredFlag_"""></div></div>"
	..i strtype["textbox" d
	...i requiredFlag="Y" d
	....s valueStr=valueStr_"<div class=""form-row""><div class=""form-title-right"_nameL_"""><span style=""color:red"">*</span>"_strname_"</div><div class=""form-item"" style=""width:305px;margin-left:-5px;""><input type=""text"" id="""_strCode_""" name="""_strCode_""" class=""textbox operdata"" data-title="""_strname_""" data-permission=""All"" style=""width:295px;"" data-required="""_requiredFlag_"""/></div></div>"
	...e  s valueStr=valueStr_"<div class=""form-row""><div class=""form-title-right"_nameL_""">"_strname_"</div><div class=""form-item"" style=""width:305px;margin-left:-5px;""><input type=""text"" id="""_strCode_""" name="""_strCode_""" class=""textbox operdata"" data-title="""_strname_""" data-permission=""All"" style=""width:295px;"" data-required="""_requiredFlag_"""/></div></div>"
	..i pIndex=$length(strPanel,",") d
	...s valueStr=valueStr_"</td></tr></tbody></table>"
	
	;w !,valueStr
	//新增
	i rowId="" d
	.&sql(insert into CIS_AN.OperFollowupMould values (:code,:desc,:valueStr))
	//更新
	i rowId'="" d
	.&sql(update CIS_AN.OperFollowupMould set MouldValues=:valueStr where RowId=:rowId)
	
	q SQLCODE
}

ClassMethod GetHisDateFormat(date As %String = "") As %String
{
   //DMY//YMD
	set DateFormat=$lg(^websys.ConfigurationD(1),10)   //适应系统配置的时间格式  YuanLin 20210901
	
    q DateFormat
}

}
