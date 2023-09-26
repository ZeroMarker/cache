Class web.BDPExt.UomBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// update2020-02-11
/// Creator：陈莹 
/// CreatDate: 2017-02-12
/// Description：同时保存单位和单位转换
/// Table：User.CTUOM，User.CTConFac
ClassMethod SaveEntity(Ceobj As web.BDPExt.UomEntity) As %String
{
	n (Ceobj,%session)
	s ImportResult=""
	
	
	Ts
	s FrRowID=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_UOM",Ceobj.CTCFFrUOM)  //$o(^CT("UOM",0,"Code",$ZCVT(Ceobj.CTCFFrUOM,"u"),0))   ///UPPER
	s ConFacRowID=""
	if (FrRowID=""){
		k Frobj
		s Frobj = ##class(web.Entity.CT.CTUOM).%New()
		s Frobj.CTUOMRowId = ""
		s Frobj.CTUOMCode = Ceobj.CTCFFrUOM
		s Frobj.CTUOMDesc = Ceobj.CTCFFrUOM
		s Frobj.CTUOMForeignDesc = Ceobj.CTCFFrUOM
		
		s FrSaveResult=##class(web.DHCBL.CT.CTUOM).SaveEntity(Frobj)
		s FrRowID=##class(web.BDPExt.FunLib).GetResultRowId(FrSaveResult)
		if (FrRowID=""){
			s ImportResult="大单位:"_FrSaveResult		
		}
	}
	
	
	if (FrRowID'=""){
		s ToRowID=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_UOM",Ceobj.CTCFToUOM)  // $o(^CT("UOM",0,"Code",$zcvt(Ceobj.CTCFToUOM,"u"),0))   ///UPPER
		if (ToRowID=""){
			k Toobj
			s Toobj = ##class(web.Entity.CT.CTUOM).%New()
			s Toobj.CTUOMRowId = ""
			s Toobj.CTUOMCode = Ceobj.CTCFToUOM
			s Toobj.CTUOMDesc = Ceobj.CTCFToUOM
			s Toobj.CTUOMForeignDesc = Ceobj.CTCFToUOM
		
			s ToSaveResult=##class(web.DHCBL.CT.CTUOM).SaveEntity(Toobj)
			s ToRowID=##class(web.BDPExt.FunLib).GetResultRowId(ToSaveResult)
			if (ToRowID=""){
				s ImportResult="基本单位:"_ToSaveResult		
			}
		
		}
		
		if (ToRowID'=""){
			k ConFacobj
			s ConFacobj = ##class(web.Entity.CT.CTConFac).%New()
			s ConFacobj.CTCFRowId = ""
			s ConFacobj.CTCFFrUOMDR= FrRowID
			s ConFacobj.CTCFToUOMDR = ToRowID
			s ConFacobj.CTCFFactor = Ceobj.CTCFFactor
			s ConFacobj.CTCFActiveFlag="Y"
			s ConFacSaveResult=##class(web.DHCBL.CT.CTConFac).SaveEntity(ConFacobj)
			s ConFacRowID=##class(web.BDPExt.FunLib).GetResultRowId(ConFacSaveResult)
			if (ConFacRowID=""){
				s ImportResult="单位转换:"_ConFacSaveResult		
			}
			
		}
		
	}
	
	
	if (ImportResult="")
	{
		Tc
		s ImportResult="{success:'true',id:'"_ConFacRowID_"'}" 
	}
	else
	{
		Tro	
	}
	
	q ImportResult
}

/// Creator：陈莹 
/// CreatDate: 2017-03-2809-11
/// Description：获取从单位到单位的转换系数
/// Table：User.CTConFac
/// Input:fruom:从单位的描述,touom:到单位的描述
/// Return：factor
/// w ##class(web.BDPExt.UomBLL).GetFactor("kg","g")
/// w ##class(web.BDPExt.UomBLL).GetFactor("盒(10)","片")
ClassMethod GetFactor(fruomdesc, touomdesc) As %String
{
	n (fruomdesc,touomdesc)
	q:(fruomdesc="")||(touomdesc="") ""
	S factor=""
	s:fruomdesc'="" fruomdesc=$ZCONVERT(fruomdesc,"U") //$$ALPHAUP^SSUTIL4(code)
	s:touomdesc'="" touomdesc=$ZCONVERT(touomdesc,"U") //$$ALPHAUP^SSUTIL4(desc)
	q:(fruomdesc="")||(touomdesc="") ""
	s fruomid=$o(^CT("UOM",0,"Code",fruomdesc,0))
	s touomid=$o(^CT("UOM",0,"Code",touomdesc,0))
	q:(fruomid="")||(touomid="") ""
	s CTCFRowID=$O(^CT("CTCF",0,"UOM",fruomid,touomid,0))
	IF CTCFRowID'="" S factor=$p($g(^CT("CTCF",CTCFRowID)),"^",3)
	q factor
}

/// Creator：陈莹 
/// CreatDate: 2017-03-28
/// Description：校验转换系数是否符合， 例外情况: ^UOMCHECK(fruomdesc,touomdesc)=factor
/// Table：User.CTConFac
/// Input:fruom:从单位的描述,touom:到单位的描述,factor：转换系数
/// Return：1 符合，0不符合
/// w ##class(web.BDPExt.UomBLL).FactorValidate("kg","g","1000")
/// w ##class(web.BDPExt.UomBLL).FactorValidate("盒(10)","片",10)
ClassMethod FactorValidate(fruomdesc, touomdesc, factor) As %String
{
	n (fruomdesc,touomdesc,factor)
	q:(factor="")||(fruomdesc="")||(touomdesc="") 0
	if (fruomdesc="kg")&&(touomdesc="g")&&(factor=1000) q 1
	if (fruomdesc="Kg")&&(touomdesc="g")&&(factor=1000) q 1
	s flag=0
	if (fruomdesc=touomdesc)   //单位相同时 系数需要为1
	{
		if factor=1 s flag=1
		else  s flag=0	
	}
	else   ///单位不同时
	{
		if $d(^UOMCHECK(fruomdesc,touomdesc))>0
		{
			s validfactor=$g(^UOMCHECK(fruomdesc,touomdesc))
			if validfactor=factor  s flag=1	
			else  s flag=0	
			q flag
		}
		
		
		
		///获取从单位里的数字
		s lengthfr=$l(fruomdesc)
		s numberflag=0,countflag=0,frnumbervalue=""
		for i=1:1:lengthfr
		{
			s ifr=$e(fruomdesc,i)
			if (ifr?1n.n) s numberflag=1,countflag=1  
			else  s numberflag=0
			if (countflag=1)&(numberflag=0) 
			{
				q 
			}
			if (numberflag=1)&(countflag=1) 
			{
				s frnumbervalue=frnumbervalue_ifr
			}
		
		}
		if frnumbervalue="" s frnumbervalue=1
		s frnumbervalue=+frnumbervalue
		///获取到单位里的数字
		s lengthfr=$l(touomdesc)
		s numberflag=0,countflag=0,tonumbervalue=""
		for i=1:1:lengthfr
		{
			s ifr=$e(touomdesc,i)
			if ifr?1n.n s numberflag=1,countflag=1
			else  s numberflag=0
			if (countflag=1)&(numberflag=0) 
			{
				q 
			}
			if (numberflag=1)&(countflag=1) 
			{
				s tonumbervalue=tonumbervalue_ifr
			}
		
		}
		if tonumbervalue="" s tonumbervalue=1
		
		if (frnumbervalue'=0)&(tonumbervalue'=0)
		{
			
			s validfactor=frnumbervalue/tonumbervalue
			if (+validfactor)=(+factor)  s flag=1	
			else  s flag=0	
		
		}
	}
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2017-04-12
/// Description：校验大单位。小单位和转换系数在数据库中存不存在（导入药品、材料、物资、检查治疗时调用）
/// Table：User.CTConFac
/// Input:fruomid:从单位的rowid,touomid:到单位的rowid,factor：转换系数
/// Return：0存在，1不存在单位对照，2 系数不对
/// w ##class(web.BDPExt.UomBLL).IsExisted("1","2","1000")
/// w ##class(web.BDPExt.UomBLL).IsExisted("1","3",10)
ClassMethod IsExisted(fruomid, touomid, factor) As %String
{
	n (fruomid,touomid,factor)
	q:(fruomid="")||(touomid="")||(factor="") 0
	s flag=0
	if (fruomid=touomid)   //单位相同时 系数需要为1
	{
		s id=$o(^CT("CTCF",0,"UOM",fruomid,touomid,0))	 //2020-04-02 考虑没有1对1对照的情况
		if id=""
		{
			s flag=1  //不存在单位对照
		}
		else
		{
			s CTCFFactor=$p($g(^CT("CTCF",id)),"^",3)
			if (CTCFFactor=1)&&(factor=1) s flag=0
			else  s flag=2	
		}
	}
	else ///单位不同时
	{
		s idd=$d(^CT("CTCF",0,"UOM",fruomid,touomid))	
		s id=$o(^CT("CTCF",0,"UOM",fruomid,touomid,0))	
		if (idd=0)
		{
			s flag=1
		}
		else
		{
			if id'=""
			{
				s CTCFFactor=$p($g(^CT("CTCF",id)),"^",3)
				if CTCFFactor=factor s flag=0
				else  s flag=2
			}
			else
			{
				s flag=1
				
			}
		}
	}
	q flag
}

}
