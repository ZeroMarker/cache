Import sqluser

/// Creator:    yangyongtao
/// CreateDate: 2017-04-06
/// Descript:   获取咨询信息
Class web.DHCSTPHCMCONSULTREPLY Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取咨询信息
/// Creator: 	yangyongtao
/// CreateDate: 2016-12-27
/// Table:		DHC_PHConsult 
/// Descript:药学咨询列表
/// W ##Class(web.DHCSTPHCMCONSULTREPLY).QueryPhConsult("10","1","2015-01-08^2017-09-30^^")
ClassMethod QueryPhConsult(offet As %String, limit As %String, strParam As %String) As %GlobalCharacterStream
{
	n (offet,limit,strParam)
    s rows=offet
	s page=limit
	s pid=..NewPid()
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	d ..killTmpGlobal(pid)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	s StartDate=$p(strParam,"^",1)   //开始日期
	s EndDate=$p(strParam,"^",2)     //结束日期
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
    s LocDesc=$p(strParam,"^",3) //科室Desc
	s StatusFlag=$p(strParam,"^",4)  //完成状态
	I StatusFlag="全部"  S StatusFlag=""
	I StatusFlag="完成"  S StatusFlag="Y"
	I StatusFlag="未完成"  S StatusFlag="N"
	
	s conID=$p(strParam,"^",5) //咨询的ID
	s InConsDesc="" //$p(strParam,"^",4)  //咨询描述
	s consStatus=$p(strParam,"^",5)  //咨询状态
	s InconsDept=$p(strParam,"^",6)  //咨询部门
	s consTypeCode=$p(strParam,"^",7) //咨询类型                 //xiugai
	s consTypeID=##Class(web.DHCSTPHCMCONSULTREPLY).GetConsTypeByCode(consTypeCode)
	s Num=0
	s ansCount=""
	f dd=StartDate:1:EndDate d
	.s consDeptID=""
	.f  s consDeptID=$o(^DHCPHCONS(0,"DATELOC",dd,consDeptID)) Q:consDeptID=""  D
	..s consultID=""
	..f  s consultID=$o(^DHCPHCONS(0,"DATELOC",dd,consDeptID,consultID)) Q:consultID=""  D

	...q:(conID'="")&(conID'=consultID)  //咨询ID
	...;显示回复次数 duwensheng 2016-09-20
	...&sql(select count(*) into:ansCount from DHC_PHConsultDetail where PHCONTD_CON_ParRef=:consultID)
	...;s ^GGG(1)=ansCount
	...s consDate=$p(^DHCPHCONS(consultID),"^",1)  ///咨询日期
	...s:consDate'="" consDate=$zd(consDate,3)
	...s consTime=$p(^DHCPHCONS(consultID),"^",2)  ///咨询时间
	...s:consTime'="" consTime=$zt(consTime,1)
	...s consName=$p(^DHCPHCONS(consultID),"^",3)  ///咨询人
	...i consName'="" s consName=$p(^SSU("SSUSR",consName),"^",2)
	...s consTypeDR=$p(^DHCPHCONS(consultID),"^",4)  ///咨询类型
	...;Q:(consTypeID'="")&(consTypeID'=consTypeDR)
	...s consDept=$p(^DHCPHCONS(consultID),"^",5)  ///咨询部门
	...;q:(LocID'="")&(LocID'=consDept)
	...S DeptDesc="",ContactName=""
	...//i consDept'="" S ContactName=$p(^CTLOC(consDept),"^",43) //科室简码
	...i consDept'=""  s DeptDesc=$p(^CTLOC(consDept),"^",2)
	...//S DeptDescs=ContactName_"-"_DeptDesc
	...q:(LocDesc'="")&(LocDesc'=DeptDesc)
	...I DeptDesc["-" S DeptDesc=$p(DeptDesc,"-",2)
	...s consDesc=$p(^DHCPHCONS(consultID),"^",6)  ///咨询描述
	...;q:(InConsDesc'="")&(consDesc'[InConsDesc)
	...s finiFlag=$p(^DHCPHCONS(consultID),"^",7)  ///完成标志
	...i finiFlag="" s finiFlag="N"
	...q:(StatusFlag'="")&(StatusFlag'=finiFlag)
	...s consType=""  ///咨询类型
	...s quesType=+$p(^DHCPHCONS(consultID),"^",8)  ///问题类型
	...i quesType'="0" s quesType=$p($g(^DHCPHCONQT(quesType)),"^",2)
	...s consIden=$p(^DHCPHCONS(consultID),"^",9)  ///咨询身份
	...q:consIden=5   ///不显示患者咨询
	...s consIden=$s(consIden="1":"医生",consIden="2":"护士",consIden="3":"技师",consIden="4":"药师",1:"")
	...s consTele=$p(^DHCPHCONS(consultID),"^",13) ///联系电话
	...s ListData=consultID_"^"_consDate_" "_consTime_"^"_consName_"^"_consDept_"^"_consDesc_"^"_consType_"^"_quesType_"^"_consIden_"^"_consTele_"^"_finiFlag_"^"_ansCount_"^"_DeptDesc
	...s Num=Num+1
	...s ^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","QueryPhConsult",pid,Num)=ListData
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S ListTitle="consultID^consDateTime^consName^consDept^consDesc^consType^quesType^consIden^consTele^finiFlag^ansCount^DeptDesc"
	d OutBinStream.Write("[")  //输出json前缀串
	
	S quitflag=0
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","QueryPhConsult",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","QueryPhConsult",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d

    ..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"^"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
	d ..killTmpGlobal(pid)
    //D OutBinStream.OutputToDevice()
    Q OutBinStream
}

/// Descript:保存(更新)药学咨询明细
/// w ##class(web.DHCSTPHCMCONSULTREPLY).SaveConsultDetail("2","578^回复咨询^")
ClassMethod SaveConsultDetail(consultID As %String, conDataList As %String) As %String
{
	n (consultID,conDataList)
	s consUserID=$p(conDataList,"^",1)  //用户ID
	s consDesc=$p(conDataList,"^",2)    //咨询描述
	s lkConDetID=$p(conDataList,"^",3)  //关联回复ID
	s ret=..InsertConDet(consultID,consUserID,consDesc,lkConDetID)
	q ret
}

/// Descript:插入药学咨询信息
ClassMethod InsertConDet(consultID, consUserID, consDesc, lkConDetID) As %String
{
	N (consultID, consUserID, consDesc, lkConDetID)
	s flag=0          //nisijia 2016-10-10
	s LastChildSub=$o(^DHCPHCOND(consultID,"I",""),-1) 	//nisijia 2016-10-10    
 	i LastChildSub'="" d	//nisijia 2016-10-10
	.s OldconDesc=$p(^DHCPHCOND(consultID,"I",LastChildSub),"^",4) 	//nisijia 2016-10-10  
	.s:OldconDesc=consDesc flag=1	//nisijia 2016-10-10
		
	q:flag=1 0	//nisijia 2016-10-10
	S consDate=+$H               
	S consTime=$p($H,",",2)              //记录日期
	S childSub=$o(^DHCPHCOND(consultID,"I",""),-1)+1
		
	&SQL(Insert Into DHC_PHConsultDetail(PHCONTD_CON_ParRef,PHCONTD_ChildSub,PHCONTD_Date,PHCONTD_Time,PHCONTD_User_Dr,PHCONTD_Desc,PHCONTD_Cont_Dr) 
		Values(:consultID,:childSub,:consDate,:consTime,:consUserID,:consDesc,:lkConDetID))
	Q SQLCODE
}

/// Descript: 设置完成状态
/// w ##class(web.DHCSTPHCMCONSULTREPLY).setConsultComplete("1","N")
ClassMethod setConsultComplete(consultID, consComFlag) As %String
{
	N (consultID,consComFlag)
	&SQL(Update DHC_PHConsult Set PHCON_FinishFlag=:consComFlag Where PHCON_RowID=:consultID)
	Q SQLCODE
}

/// Description: 科室
/// Creator:     yangyongtao
/// Table: 		 CT_LOC
/// Output:  	 所有科室描述（下拉框显示） 
/// Others:		 w ##class(web.DHCSTPHCMCONSULTREPLY).GetAllLoc("30","1","病案室") 
ClassMethod GetAllLoc(offet As %String, limit As %String, params As %String) As %GlobalCharacterStream
{
    n (offet,limit,params)
    s rows=offet
	s page=limit
	S params=$ZCONVERT(params,"U")
	S End = page*rows
	S Start = (page-1)*rows+1
    s pid=..NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
	S h=0,count=0
	S ID="0"
	F  S ID=$o(^CTLOC(ID)) Q:ID=""  D
	.S Code=$p(^CTLOC(ID),"^",1) //代码
	.S Desc=$p(^CTLOC(ID),"^",2) //描述
	.S ContactName=$p(^CTLOC(ID),"^",43) //科室简码
	.S ContactName=$ZCONVERT(ContactName,"U") 
    .S ContactNameDesc=ContactName_"-"_Desc
    .q:(params'="")&(ContactNameDesc'[params) //判断admeCode是否为空，'[ 为包含的意思
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc
	.S ^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","GetAllLoc",pid,h)=TempStr
	
	//Q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	d OutBinStream.Write("[")  //输出json前缀串
	//W ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","GetAllLoc",pid,index)) Q:index=""  D
	.S mdata=$g(^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","GetAllLoc",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
    //D OutBinStream.OutputToDevice()
    Q OutBinStream
}

/// description: 获取科室ComboBox
/// Creator: 	 yangyongtao
/// CreatDate:	 2016-12-05
/// input:  	 Start(起始数值)  Limit(增长数值),安全组id,科室名称
/// D ##Class(web.DHCSTPHCMCONSULTREPLY).GetDept()
ClassMethod GetDept()
{
    S result = ##class(%Library.ResultSet).%New()
    S sqlStr="Select CTLOC_RowID,CTLOC_Desc from CT_LOC"
    D result.Prepare(sqlStr)
    D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		S RowId = result.Data("CTLOC_RowID")
		S Description = result.Data("CTLOC_Desc")
		S tmp=RowId_"^"_Description
		S count = count+1
		I count=1 D
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	W "]"
}

/// Descript: 通过代码获取咨询类型ID    //xiugai
/// w ##Class(web.DHCSTPHCMCONSULTQUERY).GetConsTypeByCode("PHC")
ClassMethod GetConsTypeByCode(ConsTypeCode As %String) As %String
{
	n (ConsTypeCode)
	Q:ConsTypeCode="" ""
	s ConsTypeID=$o(^DHCPHCONT(0,"Code",$$ALPHAUP^SSUTIL4(ConsTypeCode),""))
	s ^F("q")=ConsTypeID
	Q ConsTypeID
}

/// Descript:咨询答复明细列表
/// Creator: 	yangyongtao
/// CreateDate: 2016-12-27
/// w ##Class(web.DHCSTPHCMCONSULTREPLY).QueryConsultBakDetList("100","1","1")
ClassMethod QueryConsultBakDetList(offet As %String, limit As %String, consultID As %String) As %GlobalCharacterStream
{
	n (offet,limit,consultID)
	s pid=..NewPid()
	s rows=offet
	s page=limit
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	d ..killTmpGlobal(pid)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	s Num=0
	s CH=""
	f  s CH=$o(^DHCPHCOND(consultID,"I",CH)) Q:CH=""  D
	.s consItmID=consultID_"||"_CH
	.s consDDate=$p(^DHCPHCOND(consultID,"I",CH),"^",1)
	.s:consDDate'="" consDDate=$zd(consDDate,3)  ///咨询日期
	.s consDTime=$p(^DHCPHCOND(consultID,"I",CH),"^",2)
	.s:consDTime'="" consDTime=$zt(consDTime,1)  ///咨询时间
	.s consDName=""
	.s consDUserID=$p(^DHCPHCOND(consultID,"I",CH),"^",3)
	.i consDUserID'="" s consDName=$p(^SSU("SSUSR",consDUserID),"^",2)
	.s consDLoc=..getUserLoc(consDUserID) //咨询所在科室
	.s consDPrvTpDesc=..GetCarPrvTp(consDUserID) //咨询人职称
	
	.s consDDesc=$p(^DHCPHCOND(consultID,"I",CH),"^",4) ///描述
	.s consDOkFlag=$p(^DHCPHCOND(consultID,"I",CH),"^",6) ///采纳标志
	.
	.s ListData=consItmID_"^"_consDDate_" "_consDTime_"^"_consDName_"^"_consDDesc_"^"_consDOkFlag_"^"_consDLoc_"^"_consDPrvTpDesc
	.
	.s Num=Num+1
	.s ^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","QueryConsultBakDet",pid,Num)=ListData
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S ListTitle="consItmID^consDDate^consDName^consDDesc^consDOkFlag^consDLoc^consDPrvTpDesc"
	d OutBinStream.Write("[")  //输出json前缀串
	
	S quitflag=0
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","QueryConsultBakDet",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","QueryConsultBakDet",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d

    ..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"^"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
	d ..killTmpGlobal(pid)
    //D OutBinStream.OutputToDevice()
    Q OutBinStream
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","QueryPhConsult",pid)
	k ^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","QueryConsultBakDet",pid)
	k ^TMP("DHCAPP","web.DHCSTPHCMCONSULTREPLY","GetAllLoc",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCAPP("DHCAPPCONSULTQUERY"))
}

/// Creator:    yangyongtao
/// CreateDate: 2017-08-10
/// Descript:   咨询所在科室
/// InPut:      UserID-用户ID
/// OutPut:     科室
/// w ##Class(web.DHCSTPHCMCONSULTREPLY).getUserLoc("578")
ClassMethod getUserLoc(userId As %String) As %ListOfDataTypes
{
		n (userId)
		s ctlocdr=$p(^SSU("SSUSR",userId),"^",4)
		s ctloc=$p(^CTLOC(ctlocdr),"^",2)
		i $f(ctloc,"-") s ctloc=$p(ctloc,"-",2)
        q ctloc
}

/// Creator:    yangyongtao
/// CreateDate: 2017-08-10
/// Descript:   咨询人职称
/// InPut:      UserID-用户ID
/// OutPut:     职称描述
/// w ##Class(web.DHCSTPHCMCONSULTREPLY).GetCarPrvTp("")
ClassMethod GetCarPrvTp(UserID As %String) As %String
{
	n (UserID)
	Q:UserID="" ""
	s CareProvID=$p(^SSU("SSUSR",UserID),"^",14)
	Q:CareProvID="" ""
	s PrvTpID=$p(^CTPCP(CareProvID,1),"^",4)
	Q:PrvTpID="" ""
	s PrvTpDesc=$p(^CT("CPT",PrvTpID),"^",2)
	Q PrvTpDesc
}

}
