Class web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.Diagnose Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod getsubDiagnoseInfo(mainmradmdr As %String, mrdiachildsub As %String) As web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PADiagnoseInfo
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PADiagnoseInfo).%New()
	set argAdmId=$p($g(^MR(mainmradmdr,"PRO",1)),"^",9)
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        	//业务域
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_argAdmId   		//全局就诊id
	set subObj.padhosdiagid=mainmradmdr_"||"_mrdiachildsub    				//院内诊断唯一id
	set subObj.padreldiagid=businessfieldcode_"_"_subObj.padhosdiagid 		//全局诊断id
	set subObj.updatedate=$zd(+$h,3)      									//时间戳
	set subObj.updatetime=$zt($p($h,",",2))   								//时间戳
	set admDiagTypeCode="",admDiagTypeDesc=""
	set admDiagTypeId=$g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",1))
	set:admDiagTypeId'="" admDiagTypeCode=$p($g(^MRC("DTYP",admDiagTypeId)),"^",1)
	set:admDiagTypeId'="" admDiagTypeDesc=$p($g(^MRC("DTYP",admDiagTypeId)),"^",2)
	set mricdid = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub)),"^",1)
    if (mricdid="") {
	    set mricdCode="",mricdDesc=""
	    set:$d(^MR(mainmradmdr,"DIA",mrdiachildsub,"DES",1)) mricdDesc=^MR(mainmradmdr,"DIA",mrdiachildsub,"DES",1)  //取非icd诊断描述
	    }
	else {
	    s mricdCode = $p($g(^MRC("ID",mricdid)),"^",1)
	    s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
	    }

	set subObj.paddiagcode=mricdid   									//	诊断代码
	set subObj.paddiagdesc=mricdDesc  									//	诊断描述 
	set padupdateuserid=$p($g(^MR(mainmradmdr,"DIA",mrdiachildsub)),"^",12)
	set mricdRemark=$p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"DES",1)),"^")
	set diagdocid=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.UserUtil).queryCarepoovidByUserid(padupdateuserid)
	set subObj.paddiagdoccode=diagdocid
	set subObj.paddiagtype=admDiagTypeDesc    							//诊断类型
	set:subObj.paddiagtype="" subObj.paddiagtype="初步诊断"
	set subObj.padremarks=mricdRemark    								//备注
	set MRDIADate=$p($g(^MR(mainmradmdr,"DIA",mrdiachildsub)),"^",7)
	set MRDIATime=$p($g(^MR(mainmradmdr,"DIA",mrdiachildsub)),"^",8)
	set:MRDIADate'="" subObj.paddiagdate=$zd(MRDIADate,3)   			//诊断日期paddiagdate
	set:MRDIATime'="" subObj.paddiagtime=$zt(MRDIATime)  				//诊断时间
	set padupdatedate=$p($g(^MR(mainmradmdr,"DIA",mrdiachildsub)),"^",19)
	set padupdatetime=$p($g(^MR(mainmradmdr,"DIA",mrdiachildsub)),"^",20)
	set:padupdatedate'="" subObj.padupdatedate=$zd(padupdatedate,3)   	//最后更新日期
	set:padupdatetime'="" subObj.padupdatetime=$zt(padupdatetime)  		//最后更新时间

	set subObj.padupdateusercode=padupdateuserid
	set MainDiagFlag=$p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,1)),"^",20)
	if MainDiagFlag="Y" {                								//诊断级别  主要诊断，次要诊断
		set subObj.paddiagcategory="主要诊断"
	}
	else {
		set subObj.paddiagcategory="次要诊断"
	}
	set DiagnosLeavel="" // $P(^MR(mainmradmdr,"DIA",mrdiachildsub,"EPR"),"^",1)     	// 诊断级别(1,2,3)
	set DiagStatDr=$p($g(^MR(mainmradmdr,"DIA",mrdiachildsub)),"^",9) 					//诊断状态
	set seq=0, sub=""
	for {
		set sub=$o(^MR(mainmradmdr,"DIA",sub))
		set seq=seq+1
		q:sub=""
		q:sub=mrdiachildsub
	}
	set subObj.paddiagseq=seq   //	诊断序号	
	quit subObj
}

/// Creator：wl
/// CreatDate：2020-12-25
/// Description：根据id取就诊的所有诊断记录表(ACC0007)
/// Table：MR_Diagnos表rowid
/// Input：mrdiagid：过敏表id
/// Output：
/// Return：数据中心pa_diagnose患者诊断记录表((json)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.DiagnoseInfo).DiagnosBymrdiagid("466653||299")
ClassMethod DiagnosBymrdiagid(mrdiagid As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Data).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	set mainmradmdr=+mrdiagid
	///对诊断在HIS是否存在进行判断
	set mrdiachildsub=$p(mrdiagid,"||",2)
	if '$d(^MR(mainmradmdr,"DIA",$p(mrdiagid,"||",2))){
		set obj.handtype="K"
	}else{
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PADiagnoseInfo).%New()
		set subObj=..getsubDiagnoseInfo(mainmradmdr,mrdiachildsub)
		d obj.PADiagnoseInfoList.Insert(subObj)
	}
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

/// Creator：wl
/// CreatDate：2020-12-25
/// Description：根据id取就诊的所有诊断记录表(ACC0007)历史数据Global
/// Table：MR_Diagnos表rowid
/// Input：mrdiagid：诊断表id
/// Output：
/// Return：数据中心pa_diagnose患者诊断记录表((Global)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.Diagnose).DiagnosGlobal("1","6314734")
ClassMethod DiagnosGlobal(strmainmradmdr As %String, endmainmradmdr As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("padiagnose")=$lb("诊断id","就诊id","诊断代码","诊断描述","诊断类型","诊断级别","诊断序号","诊断医生代码","诊断日期","诊断时间","最后更新人编码","最后更新日期","最后更新时间","备注","更新日期","更新时间")
	if (strmainmradmdr="")||(endmainmradmdr="") {
		quit "-1^id不能为空"
	}
	set mainmradmdr="",con=0,strtime=$zt($p($now(),",",2))
	for mainmradmdr=strmainmradmdr:1:endmainmradmdr{	
		continue:$d(^MR(mainmradmdr))=0
		set mrdiachildsub=0
		for{
			set mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
			quit:mrdiachildsub=""
			set mradmid=mainmradmdr_"||"_mrdiachildsub
			set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PADiagnoseInfo).%New()
			set subObj=..getsubDiagnoseInfo(mainmradmdr,mrdiachildsub)
			set ^ExportHistoryData("padiagnose",mradmid)=$lb(mradmid,subObj.paadmrelvisitnumber,subObj.paddiagcode,subObj.paddiagdesc,
														subObj.paddiagtype,subObj.paddiagcategory,subObj.paddiagseq,subObj.paddiagdoccode,
														subObj.paddiagdate,subObj.paddiagtime,
														subObj.padupdateusercode,subObj.padupdatedate,subObj.padupdatetime,
														subObj.padremarks,subObj.businessfieldcode,subObj.padreldiagid)
			set con=con+1
			set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strmainmradmdr, endmainmradmdr, con, mradmid)
		}
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
