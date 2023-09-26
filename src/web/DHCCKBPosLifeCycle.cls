Import SQLUser

Class web.DHCCKBPosLifeCycle Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	获取岗位权限表
/// Creator:		bc
/// CreateDate:		2022-8-31
/// w ##class(web.DHCCKBPosLifeCycle).Queryposlifecycle("JobData")
ClassMethod Queryposlifecycle(AddAttrCode = "") As %String
{
	n (AddAttrCode)
    s count=0
    s Id=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(AddAttrCode),""))
    b ;1
    s ListTitle="ID^postID^encoded^post"
    w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	
	s rowid=""
	s post=""
	s postID=""
	for  s rowid=$o(^CT.CKB.PDSS.CommonDictionI("Parref",$SYSTEM.Util.Collation(Id,3),rowid)) Q:rowid=""  d
	.q:rowid=0
	.s:rowid'="" postID=$lg($g(^CT.CKB.PDSS.CommonDictionD(rowid)),4) 	  //周期节点
 	.s:rowid'="" post=$lg($g(^CT.CKB.PDSS.CommonDictionD(rowid)),3)
 	.s:rowid'="" encoded= $lg($g(^CT.CKB.PDSS.CommonDictionD(rowid)),2)
	.s ListData=rowid_"^"_postID_"^"_encoded_"^"_post
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json结尾符
	Q ""
}

/// Description:	获取权限类别表
/// Creator:		bc
/// CreateDate:		2022-8-31
/// w ##class(web.DHCCKBPosLifeCycle).Querylist()
ClassMethod Querylist() As %String
{
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s arrylist=##class(web.DHCCKBCommon).GetAuthCat(1)
	s len = $l(arrylist,":")
	f i=1:1:len-1  d
	.s itemstr=$p(arrylist,",",i)
	.s code=$p(itemstr,":",1)
	.s type=$p(itemstr,":",2)
	.s tempstr=code_"^"_type
	.s ^TMP("DHCCKB","web.DHCCKBPosLifeCycle","GetDicListByAttrCode",pid,i)=tempstr     // 数据存储
	///转换数据为Json格式
 	s title="code^type" // 列title 
	w "[" 		//  输出json前缀串
 	s count=0,index=""
 	f  s index=$o(^TMP("DHCCKB","web.DHCCKBPosLifeCycle","GetDicListByAttrCode",pid,index)) q:index=""  d
 	.s mdate=$g(^TMP("DHCCKB","web.DHCCKBPosLifeCycle","GetDicListByAttrCode",pid,index))
 	.s count = count+1
	
 	.i count=1 d
 	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
 	.e  d
 	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
 	w "]"
 	d ..killTmpGlobal(pid) //k掉临时global
 	q ""
}

/// Description:	获取生命周期表
/// Creator:		bc
/// CreateDate:		2022-8-31
/// w ##class(web.DHCCKBPosLifeCycle).QuerylifeValue("30","1","^LifeCycleData^")
ClassMethod QuerylifeValue(rows = 30, page = 1, param = "") As %String
{
 n (rows,page,param)

 s end=page*rows
 s start=(page-1)*rows+1 
 s newid=$p(param,"^",1)
 s LifeCycleData=$p(param,"^",2)
 s type=$p(param,"^",3)
 s count=0
 s pid=##class(web.DHCCKBCommonUtil).NewPid()
 s ListTitle="id^num^lifecycle^authorization^order^code"
 ;w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
 s Id=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(LifeCycleData),""))  // 附加属性id
 s AttrCode=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("OrderNum"),"")) // 序号属性id
 s AttrID=""
 s lifecycle=""
 s authorization=""
 s order=""
 s code=""
 s num=0
 s ber=0
 s rowid=0
 s dlarowid=""
 for  s AttrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",$SYSTEM.Util.Collation(Id,3),AttrID)) Q:AttrID=""  d
 .s lifecycle=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrID)),3)
 .f  s rowid=$o(^CKB.PDSS.PosLifeCycleD(rowid))  q:rowid=""  d
 ..s jobid=$lg(^CKB.PDSS.PosLifeCycleD(rowid),2)
 ..q:jobid'=newid
 ..s typenew=$lg(^CKB.PDSS.PosLifeCycleD(rowid),3)
 ..s lifecyclenew=$lg(^CKB.PDSS.PosLifeCycleD(rowid),4)
 ..i (AttrID=lifecyclenew)&&(type=typenew) s authorization=$lg(^CKB.PDSS.PosLifeCycleD(rowid),5)
 ..i authorization="Y" s authorization="是"
 ..i authorization="N" s authorization="否"
 .s ListData=AttrID_"^"_ber_"^"_lifecycle_"^"_authorization_"^"_order_"^"_code
 .s Result=""
 .s AttrCodenew=""
 .f  s dlarowid=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",AttrID,dlarowid)) Q:(dlarowid="")||(Result'="")  d
 ..s AttrCodenew=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlarowid)),3)
 ..q:AttrCodenew'=AttrCode
 ..s Result=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlarowid)),5)
 .s ber=ber+1
 .s tempstr=AttrID_"^"_ber_"^"_Result_"^"_lifecycle_"^"_authorization_"^"_order_"^"_code
 .i Result'="" s ^TMP("DHCCKB","web.DHCCKBPosLifeCycle","GetDicListByAttrCode",pid,Result)=tempstr     // 数据存储
 .s authorization=""
 
 i '$d(^TMP("DHCCKB","web.DHCCKBPosLifeCycle","GetDicListByAttrCode",pid)) w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) //输出json结尾符
 q:'$d(^TMP("DHCCKB","web.DHCCKBPosLifeCycle","GetDicListByAttrCode",pid)) ""
	
///转换数据为Json格式
 s title="id^num^Result^lifecycle^authorization^order^code" // 列title 
 w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
 s count=0,index=""
 f  s index=$o(^TMP("DHCCKB","web.DHCCKBPosLifeCycle","GetDicListByAttrCode",pid,index)) q:index=""  d
 .s mdate=$g(^TMP("DHCCKB","web.DHCCKBPosLifeCycle","GetDicListByAttrCode",pid,index))
 .s count = count+1	
 .q:(count<start)||(count>end)
 .i count=start d
 ..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
 .e  d
 ..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
 w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count)
 d ..killTmpGlobal(pid) //k掉临时global
 q ""
}

/// Description:	(用)保存修改授权
/// Creator:		bc
/// CreateDate:		2022-8-31	
/// Input:			id^姓名^职务^岗位
/// return:			
/// other:			w ##class(web.DHCCKBPosLifeCycle).SaveUpdate("260258^AttrFlag^是^创建")
ClassMethod SaveUpdate(params As %String = "") As %String
{
	n (params)
	s len = $l(params,"&&")
	s ret = 0
	f i = 1:1:len q:(ret<0)  d
	.s tmpstr = $p(params,"&&",i)
	.s postID = $p(tmpstr,"^",1)
	.s type= $p(tmpstr,"^",2)
	.s authorization= $p(tmpstr,"^",3)
	.s lifecycle= $p(tmpstr,"^",4)
	.s ret = ..SaveUsertype(tmpstr)
	q ret
}

/// other:			w ##class(web.DHCCKBPosLifeCycle).SaveUsertype("260258^AttrFlag^是^创建")
ClassMethod SaveUsertype(tmpstr) As %String
{
	n (tmpstr)
	s postID = $p(tmpstr,"^",1)
	s type= $p(tmpstr,"^",2)
	s authorization= $p(tmpstr,"^",3)
	s lifecycle= $p(tmpstr,"^",4)
	i authorization="是" s authorization="Y"
	i authorization="否" s authorization="N"
	&SQL(
	Select CD_RowID INTO  :life
	FROM CT_CKB_PDSS.CommonDiction
	WHERE CD_Desc=:lifecycle
	)
	&SQL(
	Select count(*) INTO  :Numnew
	FROM CKB_PDSS.PosLifeCycle
	WHERE PLC_Job_Dr=:postID AND PLC_AuthType=:type AND PLC_LifeNode=:life
	)
	i Numnew=1 d
	.s ret = ..UpdateUser(tmpstr)	
	e  d
	.s ret = ..SaveUser(tmpstr)	// ret是SQLCODE
	q ret
}

/// Description:	新增授权
/// Creator:		bc
/// CreateDate:		2022-8-31	
/// Input:			id^姓名^职务^岗位
/// return:			
/// other:			w ##class(web.DHCCKBPosLifeCycle).SaveUser("235460^实体^N^创建")
ClassMethod SaveUser(tmpstr) As %String
{
	n (tmpstr)
	s postID = $p(tmpstr,"^",1)
	s type= $p(tmpstr,"^",2)
	s authorization= $p(tmpstr,"^",3)
	s lifecycle= $p(tmpstr,"^",4)
	i authorization="是" s authorization="Y"
	i authorization="否" s authorization="N"
	;&SQL(
	;Select count(*) INTO  :Num
	;FROM CKB_PDSS.PosLifeCycle
	;WHERE PLC_Job_Dr=:postID AND PLC_AuthType=:type AND PLC_LifeNode=:lifecycle AND PLC_AuthFlag=:authorization
	;)
	;i Num'=0 Q -99
	&SQL(
	Select CD_RowID INTO  :life
	FROM CT_CKB_PDSS.CommonDiction
	WHERE CD_Desc=:lifecycle
	)	
	&SQL(
	INSERT INTO CKB_PDSS.PosLifeCycle
	(PLC_Job_Dr,PLC_AuthType,PLC_LifeNode,PLC_AuthFlag)
	VALUES
	(:postID,:type,:life,:authorization)
	)
	q SQLCODE
}

/// Description:	保存修改岗位(用)
/// Creator:		bc
/// CreateDate:		2022-8-31	
/// Input:			id^姓名^职务^岗位
/// return:			
/// other:			w ##class(web.DHCCKBPosLifeCycle).SaveUpdatenew("^333^333^JobData")
ClassMethod SaveUpdatenew(params As %String = "") As %String
{
	n (params)
	s len = $l(params,"&&")
	s ret = 0
	f i = 1:1:len q:(ret<0)  d
	.s tmpstr = $p(params,"&&",i)
	.s RowID= $p(tmpstr,"^",1)
	.s encoded = $p(tmpstr,"^",2)
	.s post= $p(tmpstr,"^",3)
	.s ClientIPAdd= $p(tmpstr,"^",4)
	.i RowID="" d
	..s ret = ..SaveUsernew(tmpstr)	// ret是SQLCODE
	.e  d
	..s ret = ..Updatenew(tmpstr)
	q ret
}

/// Description:	修改岗位(用)
/// Creator:		bc
/// CreateDate:		2022-8-31	
/// other:			w ##class(web.DHCCKBPosLifeCycle).Updatenew("235460^AuditJob1^审批岗^235458")
ClassMethod Updatenew(tmpstr) As %String
{
	
	n (tmpstr)
	s dicRowID=""
	s RowID= $p(tmpstr,"^",1)
	s encoded = $p(tmpstr,"^",2)
	s post= $p(tmpstr,"^",3)
	s ClientIPAdd= $p(tmpstr,"^",4)
	S dicNum=$o(^CT.CKB.PDSS.CommonDictionD(dicRowID),-1)+1
	i encoded="" q -99
	i post="" q -99
	
	&SQL(
	Select count(*) INTO  :Num
	FROM CT_CKB_PDSS.CommonDiction
	WHERE CD_Code=:encoded AND CD_Desc=:post 
	)
	i Num'=0 q -100
	
	&sql(
	update CT_CKB_PDSS.CommonDiction  
	set CD_Code=:encoded, CD_Desc=:post 
	where CD_RowID=:RowID
	)
	
	q SQLCODE
}

/// Description:	新增岗位(用)
/// Creator:		
/// CreateDate:		2022-8-31	
/// Input:			id^姓名^职务^岗位
/// return:			
/// other:			w ##class(web.DHCCKBPosLifeCycle).SaveUsernew("^333^333^JobData")
ClassMethod SaveUsernew(tmpstr) As %String
{
	n (tmpstr)
	s dicRowID=""
	s encoded = $p(tmpstr,"^",2)
	s post= $p(tmpstr,"^",3)
	s ClientIPAdd= $p(tmpstr,"^",4)
	i encoded="" q -99
	i post="" q -99
	
	&SQL(
	Select CD_RowID INTO  :ClientIP
	FROM CT_CKB_PDSS.CommonDiction
	WHERE CD_Code=:ClientIPAdd
	)
	&SQL(
	Select count(*) INTO  :Num
	FROM CT_CKB_PDSS.CommonDiction
	WHERE CD_Code=:encoded AND CD_Desc=:post AND CD_Parref_Dr=:ClientIP
	)
	i Num'=0 q -100
	&SQL(
	INSERT INTO CT_CKB_PDSS.CommonDiction
	(CD_Code,CD_Desc,CD_Parref_Dr,CD_Link_Dr)
	VALUES
	(:encoded,:post,:ClientIP,:null)
	)
	q SQLCODE
}

/// Description:	修改授权(用)
/// Creator:		
/// CreateDate:		2022-8-31	
/// Input:			id^姓名^职务^岗位
/// return:			
/// other:			w ##class(web.DHCCKBPosLifeCycle).UpdateUser("260258^AttrFlag^是^创建")
ClassMethod UpdateUser(tmpstr) As %String
{
	n (tmpstr)
	s postID = $p(tmpstr,"^",1)
	s type= $p(tmpstr,"^",2)
	s authorization= $p(tmpstr,"^",3)
	s lifecycle= $p(tmpstr,"^",4)
	i authorization="是" s authorization="Y"
	i authorization="否" s authorization="N"
	&SQL(
	Select CD_RowID INTO  :life
	FROM CT_CKB_PDSS.CommonDiction
	WHERE CD_Desc=:lifecycle
	)
	
	
	&SQL(
	Select count(*) INTO  :Num
	FROM CKB_PDSS.PosLifeCycle
	WHERE PLC_Job_Dr=:postID AND PLC_AuthType=:type AND PLC_LifeNode=:life AND PLC_AuthFlag=:authorization
	)
	i Num'=0 Q -100
	&SQL(
	UPDATE CKB_PDSS.PosLifeCycle
	SET PLC_AuthFlag=:authorization
	WHERE PLC_Job_Dr=:postID AND PLC_AuthType=:type AND PLC_LifeNode=:life
	)
	q SQLCODE
}

/// Description:	删除岗位字典表
/// Creator:		 bc
/// CreateDate:		2022-8-31	
/// Input:			UserID
/// return:			0成功 非0 失败
/// other:			w ##class(web.DHCCKBPosLifeCycle).DeleteDic(122)
ClassMethod DeleteDic(RowID) As %String
{
	n (RowID)
	&SQL(
	DELETE FROM CT_CKB_PDSS.CommonDiction
	WHERE CD_RowID=:RowID
	)

	q SQLCODE
}

/// Description:	删除生命周期表
/// Creator:		 bc
/// CreateDate:		2022-8-31	
/// Input:			UserID
/// return:			0成功 非0 失败
/// other:			w ##class(web.DHCCKBPosLifeCycle).DeleteDicnew("235460","实体","是","创建")
ClassMethod DeleteDicnew(RowID, type, authorization, lifecycle) As %String
{
	n (RowID,type,authorization,lifecycle)
	i authorization="是" s authorization="Y"
	i authorization="否" s authorization="N"
	&SQL(
	Select CD_RowID INTO  :life
	FROM CT_CKB_PDSS.CommonDiction
	WHERE CD_Desc=:lifecycle
	)	
	&SQL(
	DELETE FROM CKB_PDSS.PosLifeCycle
	WHERE PLC_Job_Dr=:RowID and PLC_AuthType=:type and PLC_LifeNode=:life and PLC_AuthFlag=:authorization
	)

	q SQLCODE
}

/// Description: 更新导出元素序号
/// Creator:     baicong
/// CreateDate:  2022-02-25 
/// Table:		 web.DHCCKBPosLifeCycle
/// Input:  	 input:id^顺序号^id^顺序号
/// Return: 	 更新成功 0,更新失败 非0
/// Others:		 w ##class(web.DHCCKBPosLifeCycle).UpdExpFieldNum("260256^5^260255^6")
ClassMethod UpdExpFieldNum(input) As %String
{
	N (input)
	s dlarowid=""
	s dlarowidnew=""
	S currowid=$p(input,"^",1)
	S curordernum=$p(input,"^",2)
	S lastrowid=$p(input,"^",3)
	S lastnum=$p(input,"^",4)
	
	
	
	&sql(update CT_CKB_PDSS.DicLinkAttr  set DLA_Result=:curordernum where DLA_Dic_Dr=:currowid)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 -1
	&sql(update CT_CKB_PDSS.DicLinkAttr  set DLA_Result=:lastnum where DLA_Dic_Dr=:lastrowid)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 -2
	
	Q 0
}

/// Others:		 w ##class(web.DHCCKBPosLifeCycle).Getparref("JobData")
ClassMethod Getparref(AddAttrCode = "") As %String
{
	n (AddAttrCode)
	s Id=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(AddAttrCode),""))
	q Id
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)	
	
	;k ^TMP("DHCCKB","web.DHCCKBPosLifeCycle","QueryDicList",pid)
	k ^TMP("DHCCKB","web.DHCCKBPosLifeCycle","GetDicListByAttrCode",pid)
	;k ^TMP("DHCCKB","web.DHCCKBPosLifeCycle","QueryDicByID",pid)
}

}
