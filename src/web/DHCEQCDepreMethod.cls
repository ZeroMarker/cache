Class web.DHCEQCDepreMethod Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:折旧方法,HIDDEN:%String,Code:%String:编码")
{
SELECT DM_Desc,
	   DM_RowID,
	   DM_Code
FROM sqluser.DHC_EQCDepreMethod
where DM_InvalidFlag = 'N' and DM_Desc like nvl(:para,'')||'%'
}

ClassMethod GetMonthDepreAmount(EquipId As %Library.String = "", DepreMethodDR As %Library.String = "") As %Library.String
{
	i DepreMethodDR="" q 0
	i $p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",1)="01" q ..GetAverageYear(EquipId)
	i $p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",1)="02" q 0
	i $p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",1)="03" q ..GetDepreciateRate(EquipId) //2009-09-13 党军
	i $p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",1)="04" q ..GetOneDepreciate(EquipId) //2009-09-13 党军
	i $p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",1)="05" q ..GetMoneySubDepre(EquipId) //2010-10-13 党军
	///q ..GetAverageYear(EquipId)
}

/// 修改:2010-10-13 党军
/// 描述:增加按照金额分段折旧
ClassMethod GetMoneySubDepre(EquipId As %Library.String = "") As %Library.String
{
	s OriginalFee = $p($g(^DHCEQEquip(EquipId)),"^",27)
	s LimitYearsNum = $p($g(^DHCEQEquip(EquipId)),"^",31)
	s NetFee=$p($g(^DHCEQEquip(EquipId)),"^",28)
	i ((OriginalFee=0)!(OriginalFee=""))
	{
		q 0
	}
	i ((LimitYearsNum=0)!(LimitYearsNum=""))
	{
		s fee="使用年限有误"
		q -1001
	}
	s fee=(OriginalFee/LimitYearsNum)/12
	s fee=$Number(fee,2)
	///如果折旧费用大于净值，则取当前净值
	i (NetFee<fee) s fee=NetFee
	q fee
}

/// 修改：2009-08-10 党军 DJ0023
/// 描述：增加按照折旧率方式进行折旧
ClassMethod GetDepreciateRate(EquipId As %Library.String = "") As %Library.String
{
	s OriginalFee=$p($g(^DHCEQEquip(EquipId)),"^",27)
	s NetFee=$p($g(^DHCEQEquip(EquipId)),"^",28) //2009-09-19 党军 begin
	s continuedepre=##class(web.DHCEQCommon).GetSysInfo("990009")
	s DepreciateRate=$p($g(^DHCEQEquip(EquipId)),"^",78)
	i DepreciateRate="" q 0
	s deprefee=OriginalFee*DepreciateRate/100 
	i continuedepre=0 d //0:折旧完之后不再继续折旧,1:折完之后继续折 
	.i NetFee<deprefee d
	..s deprefee=NetFee 
	q $Number(deprefee,2) //2009-09-19 党军 end
}

/// 修改:2009-09-13 党军
/// 描述:增加一次性折旧方式进行折旧
ClassMethod GetOneDepreciate(EquipId As %Library.String = "") As %Library.String
{
	s OriginalFee=$p($g(^DHCEQEquip(EquipId)),"^",27)
	s NetFee=$p($g(^DHCEQEquip(EquipId)),"^",28) //2009-09-19 党军
	i NetFee=0 q 0 //2009-09-19 党军
	q $Number(NetFee,2) //2009-09-13 党军
}

/// 使用年限：{Year}    
/// 原值：{OriginalFee}  
/// 净残值：{NetRemainFee}   
/// 净值：{NetFee}
/// 额定总工作量：{DesignWorkLoad}
/// 工作量：{WorkLoad}
ClassMethod GetDepreAmount(depremethod, year, originalfee, netremainfee, netfee, designworkload, workload)
{
	s expression=depremethod
	s expression=##class(web.DHCEQCommon).Replace(expression,"{Year}",year)
	s expression=##class(web.DHCEQCommon).Replace(expression,"{OriginalFee}",originalfee)
	s expression=##class(web.DHCEQCommon).Replace(expression,"{NetRemainFee}",netremainfee)
	s expression=##class(web.DHCEQCommon).Replace(expression,"{NetFee}",netfee)
	s expression=##class(web.DHCEQCommon).Replace(expression,"{DesignWorkLoad}",designworkload)
	s expression=##class(web.DHCEQCommon).Replace(expression,"{WorkLoad}",workload)
	s amount=##class(web.DHCEQTools).ParseExpression(expression)
}

/// ---平均年限法(设备ID)
ClassMethod GetAverageYear(EquipId As %Library.String = "") As %Library.String
{
	;[(设备原值-残值)/使用年限]/12
	s OriginalFee = $p($g(^DHCEQEquip(EquipId)),"^",27)
	s NetRemainFee = $p($g(^DHCEQEquip(EquipId)),"^",29)
	s LimitYearsNum = $p($g(^DHCEQEquip(EquipId)),"^",31)
	s NetFee= $p($g(^DHCEQEquip(EquipId)),"^",28)
	i ((OriginalFee=0)!(OriginalFee=""))
	{
		//s fee="设备原值有误"
		q 0
	}
	i ((LimitYearsNum=0)!(LimitYearsNum=""))
	{
		s fee="使用年限有误"
		q -1001
	}
	i NetRemainFee="" s NetRemainFee=0
	s fee=((OriginalFee-NetRemainFee)/LimitYearsNum)/12
	s fee=$Number(fee,2)
	///如果折旧费用大于净值，则取当前净值
	i (NetFee<fee) s fee=NetFee
	q fee
}

/// ---工作量法(工作量,设备ID)
ClassMethod GetWorkLoad(WorkLoad As %Library.String = "", EquipId As %Library.String = "") As %Library.String
{
	;(工作量/额定工作总量)*(设备原值-残值)
	s OriginalFee = $p($g(^DHCEQEquip(EquipId)),"^",27)
	s NetRemainFee = $p($g(^DHCEQEquip(EquipId)),"^",29)
	s DesignWorkLoadNum = $p($g(^DHCEQEquip(EquipId)),"^",36)
	i NetReaminFee="" s NetRemainFee=0
	i ((OriginalFee=0)!(OriginalFee=""))
	{
		//s fee="设备原值有误"
		q 0
	}
	i ((DesignWorkLoadNum=0)!(DesignWorkLoadNum=""))
	{
		s fee="额定工作总量有误"
		q fee
	}
	s fee=(WorkLoad/DesignWorkLoadNum)*(OriginalFee-NetRemainFee)
	s fee=$Number(fee,2)
	q fee
}

/// ---平均年限法(设备ID)
ClassMethod GetAverageYearNew(EquipId As %Library.String = "") As %Library.String
{
	;[(设备原值-残值)/使用年限]/12
	s OriginalFee = $p($g(^DHCEQEquip(EquipId)),"^",27)
	s NetRemainFee = $p($g(^DHCEQEquip(EquipId)),"^",29)
	s LimitYearsNum = $p($g(^DHCEQEquip(EquipId)),"^",31)
	s NetFee= $p($g(^DHCEQEquip(EquipId)),"^",28)
	i ((OriginalFee=0)!(OriginalFee=""))
	{
		//s fee="设备原值有误"
		q 0
	}
	i ((LimitYearsNum=0)!(LimitYearsNum=""))
	{
		s fee="使用年限有误"
		q -1001
	}
	i NetRemainFee="" s NetRemainFee=0
	s fee=((OriginalFee-NetRemainFee)/LimitYearsNum)/12
	s fee=$Number(fee,2)
	///如果折旧费用大于净值，则取当前净值
	i (NetFee<fee) s fee=NetFee
	q fee
}

/// czf 2022-02-14
/// 折旧类型放大镜
Query DepreType(para) As %SQLQuery(ROWSPEC = "TName:%String:折旧方法,TRowID:%String,TCode:%String:编码")
{
SELECT DT_Desc,
	   DT_RowID,
	   DT_Code
FROM sqluser.DHC_EQCDepreType
where DT_InvalidFlag = 'N' and DT_Desc like nvl(:para,'')||'%'
}

}
