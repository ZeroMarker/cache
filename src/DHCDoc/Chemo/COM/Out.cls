/// CTOR: QP
/// DATE: 2020-07-01
/// DESC: 化疗管理对外接口
Class DHCDoc.Chemo.COM.Out Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-07-01
/// DESC: 是否为化疗医嘱
/// IN  : 
/// OUT : 0是，1不是
/// EXEC: w ##class(DHCDoc.Chemo.COM.Out).IsChemoOrder("3||156")
ClassMethod IsChemoOrder(oeori As %String)
{
	s mRtn=0
	i $d(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori)) s mRtn=1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-07-09
/// DESC: 获取化疗药品组描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Out).GetChemoGroupDesc("169||6")
ClassMethod GetChemoGroupDesc(oeori As %String)
{
	s mRtn=""
	Q:oeori="" mRtn
	Q:'$d(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori)) mRtn
	s poid=$o(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori,""))
	Q:poid="" mRtn
	s PlanItemDR=$p(^BS.DOC.Chemo.PlanOrderD(poid),"^",2)
	Q:(PlanItemDR="")||(PlanItemDR="undefined")
	S PLID=+PlanItemDR,SID=$P(PlanItemDR,"||",2),Sub=$P(PlanItemDR,"||",3)
	s mRtn=$P(^BS.DOC.Chemo.PlanD(PLID,SID,Sub),"^",2)
	s mRtn=##class(DHCDoc.Chemo.COM.Func2).GetChemoDicDesc(mRtn)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-14
/// DESC: 是否是化疗主药
/// IN  : 
/// OUT : 0不是，1是
/// EXEC: w ##class(DHCDoc.Chemo.COM.Out).IsChemoMainDrug("231||51")
ClassMethod IsChemoMainDrug(oeori As %String)
{
	Q:'$d(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori)) 0	
	s POID=$o(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori,""))
	Q:POID="" 0	
	s PDAID=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",7)
	Q:PDAID="" 0
	s ItemDR=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",2)
	Q:ItemDR="" 0
	
	s a=##class(User.ChemoPlanItem).%OpenId(ItemDR)
	Q:'$ISObject(a) 0
	s TPLItem=a.PGITplGroupItemGetObjectId()
	Q:TPLItem="" 0
	s b=##class(User.ChemoTemplateItem).%OpenId(TPLItem)
	Q:'$ISObject(b) 0
	s mainFlag=b.TPGIMainDrug
	d a.%Close()
	d b.%Close()
	Q:mainFlag="Y" 1
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-08-13
/// DESC: 护士执行时，更新日期化疗方案状态为完成状态
/// Note: 护士站在执行时，需要在最后一次执行调用接口
/// IN  : oeori(医嘱ID^医嘱ID)、user(操作用户)、loc(操作科室)、action(C:撤销，E:执行)
/// 
/// OUT : 0成功, 其余失败
/// EXEC: w ##class(DHCDoc.Chemo.COM.Out).OkChemoDate("453||3","12207","15","E")
ClassMethod OkChemoDate(ordList As %String, user As %String, loc As %String, action As %String)
{
	s mRtn=0
	Q:(ordList="")||(action="")||(user="")||(loc="") 0	;参数为空，不做处理
	s ^QP("OkChemoDate",111)=$LB(ordList,user,loc,action)
	s isExec="Y",ENum=0,CNum=0
	f i=1:1:$l(ordList,"^") {
		q:isExec="N"
		s oeori=$p(ordList,"^",i)
		continue:'$d(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori))	;不是化疗医嘱不做处理
		s POID=$o(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori,""))
		continue:POID="" 	
		s PDAID=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",7)
		continue:PDAID="" 	;申请不存在不做处理
		continue:(..IsChemoMainDrug(oeori)=0)	;不是化疗主药不做处理
		i action="E" {
			s POID=""
			f  s POID=$O(^BS.DOC.Chemo.PlanOrderI("PDAID",PDAID,POID)) Q:(POID="")||(isExec="N")  d
			.s order=$p(^BS.DOC.Chemo.PlanOrderD(POID),"^",1)
			.Q:(..IsChemoMainDrug(order)=0)	;不是化疗主药不做处理
			.s ENum=ENum+1
			.q:oeori=order	;本次执行的医嘱不做判断
			.b ;003
			.s isExec=##Class(web.DHCEMInterfaceCom).OrsIsAllExec(order)	;是否已经被执行过,
			
		} else {
			;只要存在化疗主药被撤销，就要改变状态
			s CNum=CNum+1
		}
		
		
	}
	i (CNum>0) {
		s status="A"
		s mList=user_$C(1)_loc_$C(1)_status
		s PDID=+PDAID
		s PDStatus=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
		Q:PDStatus="A" 0
		s mRtn=##class(DHCDoc.Chemo.BS.Date).ChgStatus(PDID,mList)
	}
	b ;001
	i (isExec="Y")&&(ENum>0) {
		//所有化疗医嘱均被执行，则更新为完成状态
		s ^QP("OkChemoDate",444)=$LB(ENum)
		s status="U"
		s mList=user_$C(1)_loc_$C(1)_status
		s PDID=+PDAID
		s PDStatus=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
		Q:PDStatus="U" 0	
		s mRtn=##class(DHCDoc.Chemo.BS.Date).ChgStatus(PDID,mList)
		s ^QP("OkChemoDate",333)=$LB(PDID,mList)
	}
	s ^QP("OkChemoDate",222)=mRtn
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-19
/// DESC: 是否为有效的化疗医嘱
/// IN  : 
/// OUT : 0不是，1是
/// EXEC: w ##class(DHCDoc.Chemo.COM.Out).IsActiveChemoOrder("3||156")
ClassMethod IsActiveChemoOrder(oeori As %String)
{
	s mRtn=0
	Q:'$d(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori)) mRtn
	s oeoriStatusDr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)	//OEC_OrderStatus
	q:oeoriStatusDr="" mRtn
	s oeoriStatusCode=$p(^OEC("OSTAT",oeoriStatusDr),"^",1)
	i oeoriStatusCode'="I" s mRtn=1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-19
/// DESC: 获取审核信息
/// IN  : 
/// OUT : 上级医生审核人^审核时间^药房审核人^审核时间
/// EXEC: w ##class(DHCDoc.Chemo.COM.Out).GetDocOKDate("669||8")
ClassMethod GetDocOKDate(oeori As %String)
{
	s mRtn=""
	Q:oeori="" mRtn
	Q:'$D(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori)) mRtn
	S POID=$O(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori,""))
	Q:POID="" 
	s PDAID=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",7)
	Q:PDAID="" mRtn
	s PDID=+PDAID,sub=$p(PDAID,"||",2)
	//s PDStatus=$p(^BS.DOC.Chemo.PlanDateD(+PDID),"^",23)
	;
	s find=0
	s YJKDate="",YJKTime="",YJKUser="",DocDate="",DocTime="",DocName=""
	s id=""
	f  s id=$o(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub,"S",id),-1) Q:(id="")||(find=1)  d
	.s status=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub,"S",id),"^",1)
	.i (YJKDate'="")&&(DocDate'="") s find=1
	.q:find=1
	.Q:(status'="Y")&&((status'="S"))
	.i status="Y" d
	..s YJKDate=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub,"S",id),"^",2)
	..s YJKDate=##class(websys.Conversions).DateLogicalToHtml(YJKDate)
	..s YJKTime=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub,"S",id),"^",3)
	..s YJKTime=$ZT(YJKTime,2)
	..s YJKUser=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub,"S",id),"^",4)
	..i YJKUser'="" s YJKUser=$p(^SSU("SSUSR",YJKUser),"^",2)
	.i status="S" d
	..s DocDate=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub,"S",id),"^",2)
	..s DocDate=##class(websys.Conversions).DateLogicalToHtml(DocDate)
	..s DocTime=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub,"S",id),"^",3)
	..s DocTime=$ZT(DocTime,2)
	..s DocName=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub,"S",id),"^",4)
	..i DocName'="" s DocName=$p(^SSU("SSUSR",DocName),"^",2)
	
	s DocDT=DocDate_" "_DocTime
	s YJKDT=YJKDate_" "_YJKTime
	s mRtn=DocName_"^"_DocDT_"^"_YJKUser_"^"_YJKDT
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-19
/// DESC: 根据医嘱ID返回化疗医嘱类型（化疗前、化疗后等）
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Out).GetChemoGroupByOeori("1211||174")
ClassMethod GetChemoGroupByOeori(oeori As %String)
{
	s mRtn=""
	Q:oeori="" mRtn
	Q:'$D(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori)) mRtn
	S POID=$O(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori,""))
	Q:POID="" 
	s ItemDR=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",2)
	Q:ItemDR="" mRtn
	s PLID=+ItemDR,SUB=$P(ItemDR,"||",2),CH=$P(ItemDR,"||",3),ID=$P(ItemDR,"||",4)
	s TplDR=$P(^BS.DOC.Chemo.PlanD(PLID,SUB,CH,ID),"^",20)
	i TplDR'="" {
		s TPID=+TplDR,SUB=$P(TplDR,"||",2),CH=$P(TplDR,"||",3)
		s DescID=$p($g(^CF.DOC.Chemo.TemplateD(TPID,SUB,CH)),"^",2)
	} else {
		//
		s DescID=$p(^BS.DOC.Chemo.PlanD(PLID,SUB,CH),"^",2)
	}
	Q:DescID="" mRtn
	s OR=+DescID,CH=$P(DescID,"||",2)
	s mRtn=$p(^DHCDocCT("DefineData",OR,"D",CH),"^",2)
	Q mRtn
}

}
