Import SQLUser

/// Creator: 	yangyongtao
/// CreateDate: 2017-05-12
/// Descript: 	用药建议
Class web.DHCSTPHCMMEDADV Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 保存用药建议信息
/// Creator: 	yangyongtao
/// CreateDate: 2016-12-27
/// String Param="&UserID="+UserID+"&AdmDr="+AdmDr+"&medAdvContentList="+medAdvDataList;
/// Descript:保存建议明细
/// w ##class(web.DHCSTPHCMMEDADV).InsPHMedAdvDetail("","578^1103^10^用药建议^8||3")
ClassMethod InsPHMedAdvDetail(medAdvID As %String, medAdvContentList As %String) As %String
{
	N (medAdvID,medAdvContentList)
	S ret=0
	I medAdvID="" D
	.S ret=..Insert(medAdvContentList)
	E  D
	.S ret=..Update(medAdvID,medAdvContentList)
	Q ret
}

/// Description: 添加用药建议信息
/// Creator:     yangyongtao
/// CreateDate:  2017-3-31
/// Table: 		 DHC_PHAdvice,DHC_PHAdvItm ,DHC_PHAdvDetail
/// Input:  	 medAdvContentList   用户ID^就诊ID^状态^建议信息^医嘱ID
/// Return： 	 "0#"_medAdvID:保存成功标志^建议表id
ClassMethod Insert(medAdvContentList As %String) As %String
{
	N (medAdvContentList)
	S OEORI=$p(medAdvContentList,"^",5)
	S Err=0
	TS
	//用药建议
	S medAdvID=..InsPHAdvice(medAdvContentList)
	I medAdvID<0 tro
	Q:medAdvID<0 medAdvID
	
	//用药建议详情
	i medAdvContentList'="" d
	.s Err=..InsPHAdvDetail(medAdvID,medAdvContentList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	//用药建议子表(存医嘱)
	i medAdvContentList'="" d
	.s Err=..InsPHAdvItm(medAdvID,OEORI)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	TC
	Q "0#"_medAdvID
}

/// Description: 修改用药建议信息
/// Creator:     yangyongtao
/// CreateDate:  2017-3-31
/// Table: 		 DHC_PHAdvice,DHC_PHAdvItm ,DHC_PHAdvDetail
/// Input:  	 medAdvID  建议表ID    medAdvContentList   用户ID^就诊ID^状态^建议信息^医嘱ID
/// Return： 	 "0#"_medAdvID:保存成功标志^建议表id
ClassMethod Update(medAdvID As %String, medAdvContentList As %String) As %String
{
	N (medAdvID,medAdvContentList)
	S OEORI=$p(medAdvContentList,"^",5)
	S Err=0
	TS
	S medAdvID=..UpdPHAdvice(medAdvID,medAdvContentList)
	I medAdvID<0 tro
	Q:medAdvID<0 medAdvID
	
    //删除相关子表
	s Err=..DelAdvRelatInfo(medAdvID)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//用药建议详情
	i medAdvContentList'="" d
	.s Err=..InsPHAdvDetail(medAdvID,medAdvContentList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	//用药建议子表(存医嘱)
	i medAdvContentList'="" d
	.s Err=..InsPHAdvItm(medAdvID,OEORI)
	i Err'=0 tro
	q:Err'=0 "-13"
	
	TC
	Q "0#"_medAdvID
}

/// Description: 修改建议表信息
/// Creator:     yangyongtao
/// CreateDate:  2017-3-31
/// Table: 		 DHC_PHAdvice
/// Input:  	 medAdvID  建议表ID    medAdvContentList   用户ID^就诊ID^状态^建议信息^医嘱ID
/// Return： 	  ROWID
ClassMethod UpdPHAdvice(medAdvID As %String, medAdvContentList As %String) As %String
{
	N (medAdvID,medAdvContentList)
	S userID=$p(medAdvContentList,"^",1)
	S admDr=$p(medAdvContentList,"^",2)
	S curStatus=$p(medAdvContentList,"^",3)
	S advContent=$p(medAdvContentList,"^",4)
	s docUser=$p(medAdvContentList,"^",6)
	S docUserID=""
	I docUser'="" s docUserID=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(docUser),""))
	
	S date=+$h
	S time=$p($h,",",2)
    &SQL(update DHC_PHAdvice set 
	    PHA_User_Dr=:userID,PHA_Adm_Dr=:admDr,PHA_DocUser_Dr=:docUserID,PHA_Date=:date,PHA_Time=:time,
	    PHA_CurStatus=:curStatus where PHA_RowID=:medAdvID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 添加建议表信息
/// Creator:     yangyongtao
/// CreateDate:  2017-3-31
/// Table: 		 DHC_PHAdvice
/// Input:  	 medAdvContentList   用户ID^就诊ID^状态^建议信息^医嘱ID
/// Return： 	 ROWID
ClassMethod InsPHAdvice(medAdvContentList As %String) As %String
{
   
	N (medAdvContentList)
	S userID=$p(medAdvContentList,"^",1)
	S admDr=$p(medAdvContentList,"^",2)
	S curStatus=$p(medAdvContentList,"^",3)
	S advContent=$p(medAdvContentList,"^",4)
	s docUser=$p(medAdvContentList,"^",6)
	S docUserID=""
	I docUser'="" s docUserID=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(docUser),""))
	S date=+$h
	S time=$p($h,",",2)
	&SQL(Insert Into DHC_PHAdvice(PHA_User_Dr,PHA_Adm_Dr,PHA_DocUser_Dr,PHA_Date,PHA_Time,PHA_CurStatus)
	     Values(:userID,:admDr,:docUserID,:date,:time,:curStatus))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:保存医嘱明细
/// Creator:     yangyongtao
/// CreateDate:  2017-3-31
/// Table: 		 DHC_PHAdvItm
/// Input:  	 medAdvID^oeori  建议表ID^医嘱ID
/// Return： 	 quitflag
/// Others:	  w ##class(web.DHCSTPHCMMEDADV).InsPHMedAdvItm("318||122")
ClassMethod InsPHAdvDetail(medAdvID As %String, medAdvContentList As %String) As %String
{
	N (medAdvID,medAdvContentList)
	S userID=$p(medAdvContentList,"^",1)
	S admDr=$p(medAdvContentList,"^",2)
	S curStatus=$p(medAdvContentList,"^",3)
	S advContent=$p(medAdvContentList,"^",4)
	S date=+$h
	S time=$p($h,",",2)
	S childSub=$o(^DHCPHAD(medAdvID,"AD",""),-1)+1
	&SQL(Insert Into DHC_PHAdvDetail(PHAD_PHA_Parref,PHAD_ChildSub,PHAD_User_Dr,PHAD_Date,PHAD_Time,PHAD_Advice) 
		Values(:medAdvID,:childSub,:userID,:date,:time,:advContent))
	i SQLCODE'=0  Q SQLCODE
	Q SQLCODE
}

/// Descript:保存医嘱明细
/// Creator:     yangyongtao
/// CreateDate:  2017-3-31
/// Table: 		 DHC_PHAdvItm
/// Input:  	 medAdvID^oeori  建议表ID^医嘱ID
/// Return： 	 quitflag
/// Others:	  w ##class(web.DHCSTPHCMMEDADV).InsPHMedAdvItm("318||122")
ClassMethod InsPHAdvItm(medAdvID As %String, oeoriStr As %String) As %String
{
	N (medAdvID,oeoriStr)
	S quitflag=0
	S Len=$L(oeoriStr,"&&")
	F i=1:1:Len q:quitflag'="0"  d
	.S oeori=$p(oeoriStr,"&&",i)
	.S childSub=$o(^DHCPHAD(medAdvID,"AI",""),-1)+1
	.&SQL(Insert Into DHC_PHAdvItm(PHAI_PHA_Parref,PHAI_ChildSub,PHAI_OEORI_DR) 
		Values(:medAdvID,:childSub,:oeori))
	.i SQLCODE'=0 S quitflag="1"
	Q quitflag
}

/// Descript:删除用药建议相关信息表
/// w ##class(web.DHCADVMADRREPORT).DelAdvRelatInfo("239")
ClassMethod DelAdvRelatInfo(medAdvID As %String) As %String
{
	n (medAdvID)
	//用药建议详情
    i $d(^DHCPHAD(medAdvID,"AD",1)) d
	.&SQL(DELETE DHC_PHAdvDetail WHERE PHAD_PHA_Parref=:medAdvID)
	q:+$g(SQLCODE)'=0 SQLCODE
	//用药建议子表
	i $d(^DHCPHAD(medAdvID,"AI",1)) d
	.&SQL(DELETE DHC_PHAdvItm WHERE PHAI_PHA_Parref=:medAdvID)
	q:+$g(SQLCODE)'=0 SQLCODE
	q 0
}

/// Description: 获取用药建议信息
/// Creator:     yangyongtao
/// CreateDate:  2017-3-31
/// Table: 		 DHC_PHAdvItm   DHC_PHAdvDetail  
/// Input:  	 医嘱ID
/// Return： 	 advDesc建议信息
/// Others:	  w ##class(web.DHCSTPHCMMEDADV).GetAdvMesByOeori("604||11")	 
ClassMethod GetAdvMesByOeori(oeori As %String) As %String
{
	N (oeori)
	S ID="",medID=""
	S advDesc=""
	F  S ID=$o(^DHCPHAD(ID)) Q:ID=""  D
	.S sub=""
	.F  S sub=$o(^DHCPHAD(ID,"AI",sub)) Q:sub=""  D
	..S OEORIDR=$p(^DHCPHAD(ID,"AI",sub),"^",1)
	..Q:(oeori'="")&(oeori'=OEORIDR)
	..S child=""
	..F  S child=$o(^DHCPHAD(ID,"AD",child)) Q:child=""  D
	...S advDesc=$p(^DHCPHAD(ID,"AD",child),"^",4)
	...S medID=ID 
	Q medID_"#"_advDesc
}

}
