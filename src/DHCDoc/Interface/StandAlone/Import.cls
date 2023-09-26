/// Filename         :DHCDoc.Interface.StandAlone.Service
/// Description      :应急系统与his对接业务类
/// Time             :2021/11/19
/// Author           :zhouc
Class DHCDoc.Interface.StandAlone.Import Extends Base
{

/***
  **Description      :回插就诊信息后业务
  **Author           :zhouc
  **Time             :2022/02/28
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Import).AfterReturnPAAdm()
  **Parameter        :Para:就诊号^操作人员^		;ExpStr:预留字段
  **Returns          :
***/
ClassMethod AfterReturnPAAdm(Para As %String, ExpStr As %String = "")
{
	s $zt="AfterReturnPAAdmErr"
	;插入对列表
	d ..CESQueueInsert(Para,ExpStr)
	q ""
AfterReturnPAAdmErr
	s $zt=""
	q ""
}

/***
  **Description      :回插应急系统患者队列信息
  **Author           :zhouc
  **Time             :2022/02/28
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Import).CESQueueInsert()
  **Parameter        :Para:就诊号^挂号员^		;ExpStr:预留字段
  **Returns          :
***/
ClassMethod CESQueueInsert(Para As %String, ExpStr As %String = "")
{
	s EpisodeID=$p(Para,"^",1)
	s UserID=$p(Para,"^",2)
	s HospId=$p(ExpStr,"^",1)
	q:(EpisodeID="")||(EpisodeID="") "-1"
	q:'$d(^PAADM(EpisodeID)) "-1"
	
	s AdmDep=$P(^PAADM(EpisodeID),"^",4)
	s AdmDoc=$P(^PAADM(EpisodeID),"^",9)
	s AdmDocUserId=$o(^SSU("SSUSR",0,"CTPCP",AdmDoc,""))
	s MarkId=..GetCESDocMark(AdmDocUserId,AdmDep)
	;q:MarkId="" "-1"
	
	s AdmDate=$P(^PAADM(EpisodeID),"^",6)
	s AdmTime=$P(^PAADM(EpisodeID),"^",7)
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s Name=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	s PatientNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	s StatusDate=AdmDate
	s StatusTime=AdmTime
	s QueueNo=999
	s ConsultFlag=""
	s Room=""
	
	&sql(select ID into :PersDr from  SQLUser.DHCPerState where PersName='到达')
	&sql(select ID into :FirstDr from SQLUser.DHCFirstCode where firstcname='正常')
	
	s ExabInfo=##class(web.DHCOPAdmReg).GetExabInfo(AdmDep,MarkId)
	s ExabDr=$p(ExabInfo,"^",1)
	
	&SQL(Insert into SQLUser.DHCQueue
			(QueDate,QueTime,QuePersonId,QueName,QueExabDr,QueDepDr,QueMarkDr,QueNo,QuePaadmDr,QueStateDr,QueFirstDr,QueConsultFlag,QueStateDate,QueStateTime,Operuserid,QueDocDr,QueRoomDr)
		values
			(:AdmDate,:AdmTime,:PatientNo,:Name,:ExabDr,:AdmDep,:MarkId,:QueueNo,:EpisodeID,:PersDr,:FirstDr,:ConsultFlag,:StatusDate,:StatusTime,:UserID,:AdmDoc,:Room))
	q SQLCODE
}

/***
  **Description      :获取医生默认对照的有效号别
  **Author           :zhouc
  **Time             :2022/02/28
  **debugger         :w ##Class(ClassName).MethodName()
  **Parameter        :Para:就诊号^挂号员^		;ExpStr:医院id
  **Returns          :
***/
ClassMethod GetCESDocMark(UserID As %String = "", LocID As %String = "")
{
	Q:(UserID="")||(LocID="") ""
	s DocID=$P(^SSU("SSUSR",UserID),"^",14)
	s UserName=$P(^SSU("SSUSR",UserID),"^",2)
	
	s DefaultMark="",FirstMark=""
	s DHCMarkRowID=0 
	f {
		s DHCMarkRowID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID))  Q:(DHCMarkRowID="")||(DefaultMark'="")
		s ResRowID=$$GetResRowID(DHCMarkRowID,LocID)
		continue:ResRowID=""
		s:FirstMark="" FirstMark=DHCMarkRowID
		
		;未获取到默认号别时,优先获取与用户同名的,若有配置默认值,则优先取默认值配置
		s MarkDesc=$p($g(^CTPCP(DHCMarkRowID,1)),"^",2)
		s:(MarkDesc=UserName)&&(DefaultMark="") DefaultMark=DHCMarkRowID
		s ID=""
		f {
			s ID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID,ID)) q:ID=""
			s MarkDepId=$list(^User.DHCMarkDocD(ID),4)
			continue:MarkDepId'=LocID
			s isDefault=$lg(^User.DHCMarkDocD(ID),5)
			s:isDefault=1 DefaultMark=DHCMarkRowID
		}
		
	}
	q:DefaultMark'="" DefaultMark
	q FirstMark
	
GetResRowID(CTPCPDR,LocID)
	s FindResRowID=""
	s ResRowID=0
	for {
		s ResRowID=$o(^RB("RES",0,"CTPCP",CTPCPDR,LocID,ResRowID)) Q:(ResRowID="")||(FindResRowID'="")
		s ScheSt=$p(^RB("RES",ResRowID),"^",6)
		continue:ScheSt'="Y"
		s DateFrom=$p(^RB("RES",ResRowID),"^",22)
		continue:(DateFrom'="")&&(DateFrom>+$h)
		s DateTo=$p(^RB("RES",ResRowID),"^",23)
		continue:(DateTo'="")&&(DateTo<=+$h)
		s FindResRowID=ResRowID
	}
	Q FindResRowID
}

/***
  **Description      :保存从应急系统导回的单个医嘱 !非多个医嘱
  **Author           :zhouc
  **Time             :2022/02/28
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Import).SaveOrderItem()
  **Parameter        :
  **Returns          :
***/
ClassMethod SaveOrderItem(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, Doc As %String, LABDATA As %String = "", ExpStr As %String = "", ByRef ErrMsg As %String = "")
{

	s ^temp("zhouc","1018",1)=$lb(Adm,OrdItemStr,User,Loc,Doc,LABDATA,ExpStr)
	s PrescNo=$p(OrdItemStr,"^",88)
	s LabEpisodeNo=$p(OrdItemStr,"^",38)
	
	//1.生成申请单
	s OrdItemStr=..ApplyReport(Adm,OrdItemStr,User,Loc)
	
	//2.调用插入医嘱方法
	//8.5- 需要在保存医嘱的方法中添加保存处方号和申请单号的内容
	if (..%IsValidMethod("DHCDoc.Interface.Inside.ServiceOrd","SaveOrderItems")){
		//其实此时没有必要调用 "DHCDoc.Interface.Inside.ServiceOrd","SaveOrderItems" 应急系统需要保留自己的处方号和标本号 20221018
		s ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(Adm,OrdItemStr,User,Loc,Doc,"","",.ErrMsg)
	}else{
		s ret=##class(web.DHCOEOrdItem).SaveOrderItems(Adm,OrdItemStr,User,Loc,Doc,"","",.ErrMsg)
	}
	//8.5- 处方号和申请单号需要同步,保证一致
	s AfterExtStr=PrescNo_"^"_LabEpisodeNo
	d ..AfterSaveOrderItem(ret,AfterExtStr)
	
	return ret
}

ClassMethod SaveOrderItemCM(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, Doc As %String, LABDATA As %String = "", ExpStr As %String = "", ByRef ErrMsg As %String = "")
{
	if (..%IsValidMethod("DHCDoc.Interface.Inside.ServiceOrd","SaveOrderItems")){
		s ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItemsCM(Adm,OrdItemStr,User,Loc,Doc,"","",.ErrMsg)
	}else{
		s ret=##class(web.DHCOEOrdItem).SaveOrderItemsCM(Adm,OrdItemStr,User,Loc,Doc,"","",.ErrMsg)
	}
	return ret
}

ClassMethod ApplyReport(Adm, OrdItemStr, User, Loc)
{
	s LabEpisodeNo=$p(OrdItemStr,"^",38)
    s ArcimId=$p(OrdItemStr,"^",1)
    s TraType=##Class(web.DHCAPPExaReportQuery).GetTraType(ArcimId)
    q:" L E "'[(" "_TraType_" ") OrdItemStr
    
	;q:LabEpisodeNo="" OrdItemStr
	
	q:'..%IsValidMethod("web.DHCAPPInterface","InsExaReqNo") OrdItemStr
	s ServiceARCIMStr=##class(web.DHCDocOrderCommon).GetItemServiceARCIMStrMethod(Adm,OrdItemStr,User,Loc)
	
	s ARCIMStr=$p(ServiceARCIMStr,$C(2),1)
	s AutoGenARCIMStr=$p(ServiceARCIMStr,$C(2),2)
	//只补发能够自动生成申请的
	q:AutoGenARCIMStr="" OrdItemStr
	s AutoGenresult=##class(web.DHCAPPInterface).InsExaReqNo(AutoGenARCIMStr)
   
	q:AutoGenresult="" OrdItemStr
	s ApplyArcId=$p(AutoGenresult,"^",1)
	s OrderSeqNo=$p(AutoGenresult,"^",2)
	s $p(OrdItemStr,"^",59)=ApplyArcId
	s ApplyRepDr=+ApplyArcId
	
	//更新申请单中申请单号
	;&SQL(update SQLUSER.DHC_AppReport set AR_No=:LabEpisodeNo where AR_RowID=:ApplyRepDr)
	q OrdItemStr
}

ClassMethod AfterSaveOrderItem(SaveRet, ExtStr)
{
	
	q:(SaveRet=100) "-1"
	s OrdItemId=$P(SaveRet,"*",2)
	s OrdId=+OrdItemId
	s OrdSub=$p(OrdItemId,"||",2)
	s EpisodeID=$p(^OEORD(OrdId),"^",1)
	
	s ordPrescNo=$p(ExtStr,"^",1)
	s ordLabEpisodeNo=$p(ExtStr,"^",2)
	
	if (ordPrescNo'=""){
		s OldPrescNo=$P($G(^OEORD(OrdId,"I",OrdSub)),"^",14)
		&sql(update SQLUSER.OE_OrdItem set OEORI_PrescNo=:ordPrescNo where OEORI_RowId=:OrdItemId )
		if (..PrescExist(OldPrescNo,EpisodeID))&&('..PrescExist(ordPrescNo,EpisodeID)){
			s QUE1RowID=$O(^PAQUE1(0,"PrescNo",OldPrescNo,""))
			&sql(update SQLUSER.PA_Que1 set QUE1_PrescNo=:ordPrescNo where QUE1_RowID=:QUE1RowID)
		}
	}
	if (ordLabEpisodeNo'=""){
		&sql(update SQLUSER.OE_OrdItem set OEORI_LabEpisodeNo=:ordLabEpisodeNo where OEORI_RowId=:OrdItemId )		
	}
	q 0
}

ClassMethod PrescExist(prno As %String, adm As %String) As %String [ Private ]
{
	;1-yes,0-no
	quit:'adm 0
	quit:prno="" 0
	set que=0,found=0 for  set que=$o(^PAQUE1(0,"PrescNo",prno,que)) quit:(que="")  quit:found  do
	.quit:$p($g(^PAQUE1(que)),"^",3)-adm
	.set found=1
	quit found
}

/***
  **Description      :保存从应急系统导回的医嘱后处理方法 现只用于更新成组关系
  **Author           :zhouc
  **Time             :2022/02/28
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Import).SaveOrderItem()
  **Parameter        :
  **Returns          :
***/
ClassMethod AfterSaveOrder(oeorditemAry As %DynamicObject)
{
    q:((oeorditemAry="")||(oeorditemAry.%Size()<1)) ""
    f i=0:1:oeorditemAry.%Size()-1{
        #Dim orditemObj as %DynamicObject
        s orditemObj=oeorditemAry.%Get(i)
        s MastGlobalNo=orditemObj."OEORI_OEORI_Global_No"
        continue:MastGlobalNo=""
        s MastHisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("oe_orditem",MastGlobalNo)
        continue:MastHisId=""
        s ItemGlobalNo=orditemObj."OEORI_Global_No"
	    s ItemHisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("oe_orditem",ItemGlobalNo)
		&sql(update SQLUSER.OE_OrdItem set OEORI_OEORI_DR=:MastHisId where OEORI_RowId=:ItemHisId )
    }
    q ""
}

}
