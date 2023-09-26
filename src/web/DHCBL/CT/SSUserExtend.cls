/// 名称:用户信息扩展表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - ybq
/// 编写日期:2019-1-8
Class web.DHCBL.CT.SSUserExtend Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator: chenying
/// CreatDate:2019-06-25
/// Description:增加/修改
/// Table:User.SSUserExtend
/// Input:web.Entity.CT.SSUserExtend
/// Return:成功返回success:'true'和新增或修改的数据的OPERRowId;失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.CT.SSUserExtend).SaveEntity("","")
ClassMethod SaveEntity(eobj As web.Entity.CT.SSUserExtend) As %String
{
	s result=""
	s:eobj.SSUSREBirthday'="" eobj.SSUSREBirthday = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SSUSREBirthday)
	s:eobj.SSUSREBeginDate'="" eobj.SSUSREBeginDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SSUSREBeginDate)
	if $IsObject(eobj)
	{
		if (eobj.SSUSRERowId="")       
		{
			s obj=##class(User.SSUserExtend).%New()
		}
		else                           
		{
			s obj=##class(User.SSUserExtend).%OpenId(eobj.SSUSRERowId)
		
			s bobj = ##class(web.Entity.CT.SSUserExtend).%New()
			s bobj.SSUSRERowId = eobj.SSUSRERowId
			s:obj.SSUSREMaritalDR'="" bobj.SSUSREMaritalDR=obj.SSUSREMaritalDR.%Id()
			s:obj.SSUSREEducationDR'="" bobj.SSUSREEducationDR=obj.SSUSREEducationDR.%Id()
			s:obj.SSUSRECountryDR'="" bobj.SSUSRECountryDR=obj.SSUSRECountryDR.%Id()
			s:obj.SSUSRENationDR'="" bobj.SSUSRENationDR=obj.SSUSRENationDR.%Id()
			s:obj.SSUSRESexDR'="" bobj.SSUSRESexDR=obj.SSUSRESexDR.%Id()
			s bobj.SSUSREAddress = obj.SSUSREAddress
			s bobj.SSUSRESerialNo = obj.SSUSRESerialNo
			s bobj.SSUSRECertificateNo = obj.SSUSRECertificateNo
			s bobj.SSUSREPoliticalStatus = obj.SSUSREPoliticalStatus
			s bobj.SSUSREIntroduction = obj.SSUSREIntroduction
			s bobj.SSUSREImg = obj.SSUSREImg
			s bobj.SSUSREImgOrientation = obj.SSUSREImgOrientation
			s bobj.SSUSREText1 = obj.SSUSREText1
			s bobj.SSUSREText2 = obj.SSUSREText2
			s bobj.SSUSRESpeciality = obj.SSUSRESpeciality
			
			s bobj.SSUSREMulpracFlag = obj.SSUSREMulpracFlag
			s bobj.SSUSREMainpracinsFlag = obj.SSUSREMainpracinsFlag
			s bobj.SSUSREHiServType = obj.SSUSREHiServType
			s bobj.SSUSREBeginDate = obj.SSUSREBeginDate
			
			s bobj.SSUSREDrPracType = obj.SSUSREDrPracType
			s bobj.SSUSREDrProTechDuty = obj.SSUSREDrProTechDuty
			s bobj.SSUSREDrPracScpCode = obj.SSUSREDrPracScpCode
			s bobj.SSUSREProCode = obj.SSUSREProCode
			s bobj.SSUSREDclProfFlag = obj.SSUSREDclProfFlag
			s bobj.SSUSREPracticeCode = obj.SSUSREPracticeCode
			s bobj.SSUSREDrProfttlCode = obj.SSUSREDrProfttlCode
			s bobj.SSUSREBindFlag = obj.SSUSREBindFlag
			s bobj.SSUSRESiprofFlag = obj.SSUSRESiprofFlag
			s bobj.SSUSRELoclprofFlag = obj.SSUSRELoclprofFlag
			s bobj.SSUSREHiDrFlag = obj.SSUSREHiDrFlag
			s bobj.SSUSRECertType = obj.SSUSRECertType
			s bobj.SSUSRECertno = obj.SSUSRECertno
			s bobj.SSUSREBirthplace = obj.SSUSREBirthplace
		}
		
		s obj.SSUSREBirthday = eobj.SSUSREBirthday
		d obj.SSUSRECountryDRSetObjectId(eobj.SSUSRECountryDR)
		d obj.SSUSRENationDRSetObjectId(eobj.SSUSRENationDR)
		d obj.SSUSREMaritalDRSetObjectId(eobj.SSUSREMaritalDR)
		d obj.SSUSREEducationDRSetObjectId(eobj.SSUSREEducationDR)
		d obj.SSUSRESexDRSetObjectId(eobj.SSUSRESexDR)
		
		s obj.SSUSREAddress = eobj.SSUSREAddress
		s obj.SSUSRESerialNo = eobj.SSUSRESerialNo
		s obj.SSUSREIntroduction = eobj.SSUSREIntroduction
		
		s obj.SSUSREImgOrientation = eobj.SSUSREImgOrientation
		s obj.SSUSRECertificateNo = eobj.SSUSRECertificateNo
		s obj.SSUSREPoliticalStatus = eobj.SSUSREPoliticalStatus
		s obj.SSUSREText1 = eobj.SSUSREText1
		s obj.SSUSREText2 = eobj.SSUSREText2
		s obj.SSUSRESpeciality = eobj.SSUSRESpeciality
		
		s obj.SSUSREMulpracFlag = eobj.SSUSREMulpracFlag
		s obj.SSUSREMainpracinsFlag = eobj.SSUSREMainpracinsFlag
		s obj.SSUSREHiServType = eobj.SSUSREHiServType
		s obj.SSUSREBeginDate = eobj.SSUSREBeginDate
		
		s obj.SSUSREDrPracType = eobj.SSUSREDrPracType
		s obj.SSUSREDrProTechDuty = eobj.SSUSREDrProTechDuty
		s obj.SSUSREDrPracScpCode = eobj.SSUSREDrPracScpCode
		s obj.SSUSREProCode = eobj.SSUSREProCode
		s obj.SSUSREDclProfFlag = eobj.SSUSREDclProfFlag
		s obj.SSUSREPracticeCode = eobj.SSUSREPracticeCode
		s obj.SSUSREDrProfttlCode = eobj.SSUSREDrProfttlCode
		s obj.SSUSREBindFlag = eobj.SSUSREBindFlag
		s obj.SSUSRESiprofFlag = eobj.SSUSRESiprofFlag
		s obj.SSUSRELoclprofFlag = eobj.SSUSRELoclprofFlag
		s obj.SSUSREHiDrFlag = eobj.SSUSREHiDrFlag
		s obj.SSUSRECertType = eobj.SSUSRECertType
		s obj.SSUSRECertno = eobj.SSUSRECertno
		s obj.SSUSREBirthplace = eobj.SSUSREBirthplace
		
		Tstart
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			s SSUSRName=$p($g(^SSU("SSUSR",id)),"^",2)
			d:eobj.SSUSRERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_UserExtend","User.SSUserExtend","用户信息扩展表",id,SSUSRName,"U",eobj,bobj,id)
		}else{
			Trollback
			b ;1
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用户信息扩展表","web.DHCBL.CT.SSUserExtend","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}
	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	
	q result
}

/// Creator: ybq
/// CreatDate:2019-1-8
/// Description:双击修改时,从后台取数据
/// Table:User.SSUserExtend
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.SSUserExtend).OpenData("6433")
ClassMethod OpenData(id As %String) As web.BDP.sys.String
{
	s str=""
	s pobj = ##class(User.SSUserExtend).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSUserExtend).%New()
	s eobj.SSUSRERowId = id
	s:pobj.SSUSRECountryDR'="" eobj.SSUSRECountryDR=pobj.SSUSRECountryDR.%Id()
	s:pobj.SSUSRENationDR'="" eobj.SSUSRENationDR=pobj.SSUSRENationDR.%Id()
	s:pobj.SSUSREEducationDR'="" eobj.SSUSREEducationDR=pobj.SSUSREEducationDR.%Id()
	s:pobj.SSUSREMaritalDR'="" eobj.SSUSREMaritalDR=pobj.SSUSREMaritalDR.%Id()
	s:pobj.SSUSRESexDR'="" eobj.SSUSRESexDR=pobj.SSUSRESexDR.%Id()
	s eobj.SSUSREAddress = pobj.SSUSREAddress
	s eobj.SSUSRESerialNo = pobj.SSUSRESerialNo
	s eobj.SSUSREIntroduction = pobj.SSUSREIntroduction
	s eobj.SSUSREImgOrientation = pobj.SSUSREImgOrientation
	s eobj.SSUSRECertificateNo = pobj.SSUSRECertificateNo
	s eobj.SSUSREPoliticalStatus = pobj.SSUSREPoliticalStatus
	s eobj.SSUSREText1 = pobj.SSUSREText1
	s eobj.SSUSREText2 = pobj.SSUSREText2
	s eobj.SSUSRESpeciality = pobj.SSUSRESpeciality
	s eobj.SSUSREImg = pobj.SSUSREImg
	s:pobj.SSUSREBirthday'="" eobj.SSUSREBirthday=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.SSUSREBirthday)
	s eobj.SSUSREMulpracFlag = pobj.SSUSREMulpracFlag
	s eobj.SSUSREMainpracinsFlag = pobj.SSUSREMainpracinsFlag
	s eobj.SSUSREHiServType = pobj.SSUSREHiServType
	s:pobj.SSUSREBeginDate'="" eobj.SSUSREBeginDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.SSUSREBeginDate)
	
	s eobj.SSUSREDrPracType = pobj.SSUSREDrPracType
	s eobj.SSUSREDrProTechDuty = pobj.SSUSREDrProTechDuty
	s eobj.SSUSREDrPracScpCode = pobj.SSUSREDrPracScpCode
	s eobj.SSUSREProCode = pobj.SSUSREProCode
	s eobj.SSUSREDclProfFlag = pobj.SSUSREDclProfFlag
	s eobj.SSUSREPracticeCode = pobj.SSUSREPracticeCode
	s eobj.SSUSREDrProfttlCode = pobj.SSUSREDrProfttlCode
	s eobj.SSUSREBindFlag = pobj.SSUSREBindFlag
	s eobj.SSUSRESiprofFlag = pobj.SSUSRESiprofFlag
	s eobj.SSUSRELoclprofFlag = pobj.SSUSRELoclprofFlag
	s eobj.SSUSREHiDrFlag = pobj.SSUSREHiDrFlag
	s eobj.SSUSRECertType = pobj.SSUSRECertType
	s eobj.SSUSRECertno = pobj.SSUSRECertno
	s eobj.SSUSREBirthplace = pobj.SSUSREBirthplace
	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator: ybq
/// CreatDate:2019-1-8
/// Description:返回img数据
/// Table:User.SSUserExtend
/// Return:SSUSREImg^SSUSREImgOrientation
/// Other: w ##class(web.DHCBL.CT.SSUserExtend).getImg("9")
ClassMethod getImg(id As %String) As web.BDP.sys.String
{
	if (id="")
	{
		s Img=$g(^TMPSSUserExtendImg("EXTIMG"))
		k ^TMPSSUserExtendImg
		q Img
	}
	q $p($g(^SSU("SSUSR",id,"EXTIMG")),"^",1)
}

/// Creator: ybq
/// CreatDate:2019-1-8
/// Description:设置图片
/// Table:User.SSUserExtend
/// Return:SSUSREImg^SSUSREImgOrientation
/// Other: w ##class(web.DHCBL.CT.SSUserExtend).setImg("9")
ClassMethod setImg(id As %String, base64 As web.BDP.sys.String) As %String
{
	if (id="")
	{
		s ^TMPSSUserExtendImg("EXTIMG")=base64
		q "true^0"
	}
	else
	{
		s $p(^SSU("SSUSR",id,"EXTIMG"),"^",1)=base64
		q "true^"_id
	}
}

/// Other: d ##class(web.DHCBL.CT.SSUserExtend).UpdateExtend()
ClassMethod UpdateExtend() As %String
{
	s SSUSRRowId=0
	for
	{
		s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) Q:SSUSRRowId=""
		IF $D(^SSU("SSUSR",SSUSRRowId,"EXT"))
		{
			//新 性别 新改16，职工简介 8，特长13，婚姻4头像18
			
			// 原来 性别5，职工简介17，特长20，婚姻8，
			s eobj=##class(web.Entity.CT.SSUserExtend).%New()
			s eobj.SSUSRERowId=SSUSRRowId
			S eobj.SSUSREIntroduction=$P($G(^SSU("SSUSR",SSUSRRowId,"EXT")),"^",17)
			S eobj.SSUSRESpeciality=$P($G(^SSU("SSUSR",SSUSRRowId,"EXT")),"^",20)
			S eobj.SSUSRESexDR=$P($G(^SSU("SSUSR",SSUSRRowId,"EXT")),"^",5)
			S eobj.SSUSREMaritalDR=$P($G(^SSU("SSUSR",SSUSRRowId,"EXT")),"^",8)
			IF eobj.SSUSREMaritalDR="N" S eobj.SSUSREMaritalDR=2
			IF eobj.SSUSREMaritalDR="Y" S eobj.SSUSREMaritalDR=1
			w ##class(web.DHCBL.CT.SSUserExtend).SaveEntity(eobj,""),!
			
			
		}
		
	}
}

/// 返回带不可见字符的简介特长
/// id -用户rowid
/// flag - 1:简介	2:特长
/// Other: w ##class(web.DHCBL.CT.SSUserExtend).GetDataIncluTR("9","1")
ClassMethod GetDataIncluTR(id As %String, flag As %String) As %String
{
	q:id="" ""
	s re=""
	s:flag=1 re=$P($G(^SSU("SSUSR",id,"EXT")),"^",8)
	s:flag=2 re=$P($G(^SSU("SSUSR",id,"EXT")),"^",13)
	q re
}

}
