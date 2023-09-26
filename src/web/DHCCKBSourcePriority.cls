Import sqluser

Class web.DHCCKBSourcePriority Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	获取药品字典目录表
/// Creator:		bc
/// CreateDate:		2022-11-15
/// w ##class(web.DHCCKBSourcePriority).Queryposlifecycle("30","1","DrugLibaryData","用法")
ClassMethod Queryposlifecycle(rows, page, AddAttrCode = "", params = "") As %String
{
	n (rows,page,AddAttrCode,params)
	s end = page*rows
	s start=(page-1)*rows+1
    s count=0
    b ;1
    s Id=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(AddAttrCode),""))
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
 	.i params'="" q:post'[params
	.s ListData=rowid_"^"_postID_"^"_encoded_"^"_post
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json结尾符
	Q ""
}

/// Description:	根据名称查询知识来源表数据
/// Creator:		Lidong 
/// CreateDate:		2022-11-15	
/// Input:			姓名
/// return:			
/// other:			w ##class(web.DHCCKBSourcePriority).GetKnowListByKnow("50","1","测试1","")
ClassMethod GetKnowListByKnow(rows, page, KnowSource As %String = "", CatalogueID As %String = "") As %String
{
	n (rows, page,KnowSource,CatalogueID)
	s ^TMP("web.DHCCKBSourcePriority","GetKnowListByKnow") = $lb(rows, page,KnowSource)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s queryCode=KnowSource
	s queryCode = $zcvt(queryCode,"U")
	s h=0,count=0
	s RowID=""  
	s Parref=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("KnowSourceData"),""))
	f  s RowID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,RowID))  q:RowID=""  d
	.i $d(^CF.CKB.PDSS.SourcePriorityI("SourceDr","Global",RowID)) d
	..s ID=$o(^CF.CKB.PDSS.SourcePriorityI("SourceDr","Global",RowID,""))
	..s KnowSourceId=$lg(^CF.CKB.PDSS.SourcePriorityD(ID),5)
	..s KnowSource=$lg($g(^CT.CKB.PDSS.CommonDictionD(KnowSourceId)),3)
	..s IsEnable=$lg(^CF.CKB.PDSS.SourcePriorityD(ID),7)
	..i IsEnable="Y"  d
	...s IsEnableId="true"
	..i IsEnable="N"  d
	...s IsEnableId="false"
	..s Relation=$lg(^CF.CKB.PDSS.SourcePriorityD(ID),6)
	
	..s pinDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE(KnowSource)
	..q:(queryCode'="")&&($zcvt(KnowSource,"U")'[queryCode)&&(pinDesc'[queryCode)
	..s h=h+1
	..s Num=$lg(^CF.CKB.PDSS.SourcePriorityD(ID),8)
	..i Num=""  d
	...s Num=h
	..e  d
	...s Num=$lg(^CF.CKB.PDSS.SourcePriorityD(ID),8)
	..s tempstr=ID_"^"_KnowSourceId_"^"_KnowSource_"^"_IsEnable_"^"_Relation_"^"_Num_"^"_IsEnableId
	..s ^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowListByKnow",pid,Num,h)=tempstr
 	.e  d
 	..s ID=""
 	..s KnowSourceId=RowID
	..s KnowSource=$lg($g(^CT.CKB.PDSS.CommonDictionD(KnowSourceId)),3)
 	..s IsEnable="Y"
 	..s IsEnableId="true"
 	..s Relation="or"
 	..s pinDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE(KnowSource)
	..q:(queryCode'="")&&($zcvt(KnowSource,"U")'[queryCode)&&(pinDesc'[queryCode)
	..s h=h+1
	..s Num=h
	..s tempstr=ID_"^"_KnowSourceId_"^"_KnowSource_"^"_IsEnable_"^"_Relation_"^"_Num_"^"_IsEnableId
	..s ^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowListByKnow",pid,Num,h)=tempstr
	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	///转换数据为Json格式
	s title="RowID^KnowSourceId^KnowSource^IsEnable^Relation^Num^IsEnableId" // 列title 
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s count=0,Num=""
	f  s Num=$o(^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowListByKnow",pid,Num)) q:Num=""  d
	.s index=""
	.f  s index=$o(^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowListByKnow",pid,Num,index)) q:index=""  d
	..s mdate=$g(^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowListByKnow",pid,Num,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description:	根据名称查询知识来源表数据
/// Creator:		Baicong 
/// CreateDate:		2022-11-15	
/// Input:			目录id
/// return:			
/// other:			w ##class(web.DHCCKBSourcePriority).GetKnowListByKnownew("50","1","","74")
ClassMethod GetKnowListByKnownew(rows, page, KnowSource As %String = "", CatalogueID As %String = "") As %String
{
	n (rows, page,KnowSource,CatalogueID)
	s ^TMP("web.DHCCKBSourcePriority","GetKnowListByKnownew") = $lb(rows, page,KnowSource,CatalogueID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s queryCode=KnowSource
	s queryCode = $zcvt(queryCode,"U")
	s h=0,count=0
	s RowID=""  
	s Parref=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("KnowSourceData"),""))
	f  s RowID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,RowID))  q:RowID=""  d
	.i $d(^CF.CKB.PDSS.SourcePriorityI("LibDr","Lib",CatalogueID,RowID)) d
	..s ID=$o(^CF.CKB.PDSS.SourcePriorityI("LibDr","Lib",CatalogueID,RowID,""))
	..s CatalogueIDnew=$lg(^CF.CKB.PDSS.SourcePriorityD(ID),4)
	..b ;11111
	..q:CatalogueIDnew'=CatalogueID
	..s KnowSourceId=$lg(^CF.CKB.PDSS.SourcePriorityD(ID),5)
	..s KnowSource=$lg($g(^CT.CKB.PDSS.CommonDictionD(KnowSourceId)),3)
	..s IsEnable=$lg(^CF.CKB.PDSS.SourcePriorityD(ID),7)
	..i IsEnable="Y"  d
	...s IsEnableId="true"
	..i IsEnable="N"  d
	...s IsEnableId="false"
	..s Relation=$lg(^CF.CKB.PDSS.SourcePriorityD(ID),6)
	..s pinDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE(KnowSource)
	..q:(queryCode'="")&&($zcvt(KnowSource,"U")'[queryCode)&&(pinDesc'[queryCode)
	..s h=h+1
	..s Num=$lg(^CF.CKB.PDSS.SourcePriorityD(ID),8)
	..i Num=""  d
	...s Num=h
	..e  d
	...s Num=$lg(^CF.CKB.PDSS.SourcePriorityD(ID),8)
	..s tempstr=ID_"^"_KnowSourceId_"^"_KnowSource_"^"_IsEnable_"^"_Relation_"^"_Num_"^"_IsEnableId
	..s ^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowListByKnow",pid,Num,h)=tempstr
 	.e  d
 	..s ID=""
 	..s KnowSourceId=RowID
	..s KnowSource=$lg($g(^CT.CKB.PDSS.CommonDictionD(KnowSourceId)),3)
 	..s IsEnable="Y"
 	..s IsEnableId="true"
 	..s Relation="or"
	..s pinDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE(KnowSource)
	..q:(queryCode'="")&&($zcvt(UserName,"U")'[queryCode)&&(pinDesc'[queryCode)
	..s h=h+1
	..s Num=h
	..s tempstr=ID_"^"_KnowSourceId_"^"_KnowSource_"^"_IsEnable_"^"_Relation_"^"_Num_"^"_IsEnableId
	..s ^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowListByKnow",pid,Num,h)=tempstr
	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	///转换数据为Json格式
	s title="RowID^KnowSourceId^KnowSource^IsEnable^Relation^Num^IsEnableId" // 列title 
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s count=0,Num=""
	f  s Num=$o(^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowListByKnow",pid,Num)) q:Num=""  d
	.s index=""
	.f  s index=$o(^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowListByKnow",pid,Num,index)) q:index=""  d
	..s mdate=$g(^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowListByKnow",pid,Num,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description:	获取知识来源combox
/// Creator:		Lidong 
/// CreateDate:		2022-11-15	
/// Input:			
/// return:			知识来源集合
/// other:			w ##class(web.DHCCKBSourcePriority).GetKnowSourceComboxData("")
ClassMethod GetKnowSourceComboxData(q As %String = "") As %String
{
	n (q)
	s queryCode = q
	s queryCode = $zcvt(queryCode,"U")
	s ^TMP("web.DHCCKBSourcePriority","GetKnowSourceComboxData") = $lb(q)
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s h=0,count=0
	s Parref=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("KnowSourceData"),""))
	s RowID=""  
	f  s RowID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,RowID))  q:RowID=""  d
	.s KnowSourceCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),2)
	.s KnowSourceDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),3)
	.s pinDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE(KnowSourceDesc)
	.q:(queryCode'="")&&($zcvt(KnowSourceCode,"U")'[queryCode)&&(KnowSourceDesc'[queryCode)&&(pinDesc'[queryCode)
	.s h=h+1
	.s tempstr=RowID_"^"_KnowSourceDesc
	.s ^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowSourceComboxData",pid,h)=tempstr     // 数据存储
	q:h=0 ""
	///转换数据为Json格式
	s title="value^text" // 列title 
	w "[" 		//  输出json前缀串
	s count=0,index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowSourceComboxData",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCCKB","web.DHCCKBSourcePriority","GetKnowSourceComboxData",pid,index))
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	w "]"
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description:	保存或修改(用)
/// Creator:		BaiCong
/// CreateDate:		2022-11-15	
/// Input:			rowid^目录id^知识来源id^逻辑关系^是否启用^顺序级序号
/// return:			
/// other:			w ##class(web.DHCCKBSourcePriority).SaveUpdate("^^235563^or^N^235563^Global^")
ClassMethod SaveUpdate(params As %String = "") As %String
{
	n (params)
	s ^TMP("web.DHCCKBSourcePriority","SaveUpdate")=params
	s len = $l(params,"&&")
	s ret = 0
	f i = 1:1:len q:(ret<0)  d
	.s tmpstr = $p(params,"&&",i)
	.s RowID=$p(tmpstr,"^",1) 
	.s CatalogueID = $p(tmpstr,"^",2)  //目录ID
	.s KnowledgeID = $p(tmpstr,"^",3) //知识来源id
	.s Relation = $p(tmpstr,"^",4) //逻辑关系
	.s IsEnable = $p(tmpstr,"^",5) //是否启用
	.s Num = $p(tmpstr,"^",6) //顺序级序号
	.s type=$p(tmpstr,"^",7) // 类型
	.s typeID=$p(tmpstr,"^",8) //类型id
	
	.b ; //1
	.i RowID="" d
	..s ret = ..SaveUser(tmpstr)		// ret是id
	.e  d
	..s ret = ..UpdateUser(tmpstr)	// ret是SQLCODE
	q ret
}

/// Description:	保存或修改(用)
/// Creator:		BaiCong 
/// CreateDate:		2022-11-15	
/// Input:			rowid^目录id^知识来源id^逻辑关系^是否启用^顺序级序号
/// return:			
/// other:			w ##class(web.DHCCKBSourcePriority).SaveUser("^^235563^or^N^235563^Global^")
ClassMethod SaveUser(tmpstr) As %String
{
	n (tmpstr)
	
	s RowID=$p(tmpstr,"^",1) 
	s CatalogueID = $p(tmpstr,"^",2)  //目录ID
	s KnowledgeID = $p(tmpstr,"^",3) //知识来源id
	s Relation = $p(tmpstr,"^",4) //逻辑关系
	s IsEnable = $p(tmpstr,"^",5) //是否启用
	s Num = $p(tmpstr,"^",6) //顺序级序号
	s type=$p(tmpstr,"^",7) // 类型
	s typeID=$p(tmpstr,"^",8) //类型id

	&SQL(
	INSERT INTO CF_CKB_PDSS.SourcePriority
	(SP_LibDr,SP_SourceDr,SP_Relation,SP_Active,SP_Num,SP_Type,SP_TypeDr)
	VALUES
	(:CatalogueID,:KnowledgeID,:Relation,:IsEnable,:Num,:type,:typeID)
	)
	q SQLCODE
}

/// Description:	保存或修改(用)
/// Creator:		BaiCong 
/// CreateDate:		2022-11-15	
/// Input:			rowid^目录id^知识来源id^逻辑关系^是否启用^顺序级序号
/// return:			
/// other:			w ##class(web.DHCCKBSourcePriority).UpdateUser("^OtherNameProp^别名^23^26947","")
ClassMethod UpdateUser(tmpstr) As %String
{
	n (tmpstr)
	s RowID=$p(tmpstr,"^",1) 
	s CatalogueID = $p(tmpstr,"^",2)  //目录ID
	s KnowledgeID = $p(tmpstr,"^",3) //知识来源id
	s Relation = $p(tmpstr,"^",4) //逻辑关系
	s IsEnable = $p(tmpstr,"^",5) //是否启用
	s Num = $p(tmpstr,"^",6) //顺序级序号
	s type=$p(tmpstr,"^",7) // 类型
	s typeID=$p(tmpstr,"^",8) //类型id
	&SQL(
	UPDATE CF_CKB_PDSS.SourcePriority
	SET SP_LibDr=:CatalogueID,
		SP_SourceDr=:KnowledgeID,
		SP_Relation=:Relation,
		SP_Active=:IsEnable,
		SP_Num=:Num,
		SP_Type=:type,
		SP_TypeDr=:typeID
	WHERE SP_RowID=:RowID
	)
	q SQLCODE
}

/// Descript:k掉临时global
/// w ##class(web.DHCCKBSourcePriority).killTmpGlobal("199785")
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("web.DHCCKBSourcePriority","GetLevelFlagComboxData",pid)
	k ^TMP("web.DHCCKBSourcePriority","GetKnowSourceComboxData",pid)
	q ""
}

/// Description: 更新导出元素序号
/// Creator:     LiDong
/// CreateDate:  2022-02-25 
/// Table:		 CF_CKB_PDSS.SourcePriority
/// Input:  	 input:id^顺序号^id^顺序号
/// Return: 	 更新成功 0,更新失败 非0
/// Others:		 w ##class(web.DHCCKBSourcePriority).UpdExpFieldNum("1||2^1^1||1^2")
ClassMethod UpdExpFieldNum(input) As %String
{
	N (input)
	S currowid=$p(input,"^",1)
	S curordernum=$p(input,"^",2)
	S lastrowid=$p(input,"^",3)
	S lastordernum=$p(input,"^",4)
	S curordernum=$lg(^CF.CKB.PDSS.SourcePriorityD(lastrowid),8) ;$lg($g(^CT.CKB.PDSS.CommonDictionD(lastrowid)),6)
	S lastordernum=$lg(^CF.CKB.PDSS.SourcePriorityD(currowid),8) ;$lg($g(^CT.CKB.PDSS.CommonDictionD(currowid)),6)
	tstart
	&sql(update CF_CKB_PDSS.SourcePriority  set SP_Num=:curordernum where SP_RowID=:currowid)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 -1
	&sql(update CF_CKB_PDSS.SourcePriority  set SP_Num=:lastordernum where SP_RowID=:lastrowid)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 -2
	tcommit
	
	Q 0
}

}
