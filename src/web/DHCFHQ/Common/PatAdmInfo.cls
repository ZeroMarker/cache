/// 患者和就诊信息
Class web.DHCFHQ.Common.PatAdmInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod ConvertPatNo(PatNo As %String) As %String
{
	s PatNo=$tr(PatNo," ")
	s PatLen=$p(^CF("PATCF",1,3),"^",5)
	S:PatLen="" PatLen=10
 	S PatNo=$tr($justify(PatNo,PatLen,0)," ","0")
 	q PatNo
}

/// 根据医嘱ID取病人就诊指针
ClassMethod GetAdmByOeord(Str As %String = "") As %String
{
	s del="^"
 s adm="" 
 q:Str="" adm
 s oeord1=$p(Str,"||"),oeord2=$p(Str,"||",2)
 s adm=$p(^OEORD(oeord1),del,1)
 q adm
}

ClassMethod GetAdmInfoByAdm(AdmId As %String = "") As %String
{
 ;根据病人的ADMRID查找病人的信息
 s del="^"
 q:AdmId="" ""
 s papmirid=""
 s papmirid=$p(^PAADM(AdmId),del,1)
 s AdmType=$p(^PAADM(AdmId),del,2)
 s patno=+$p(^PAPER(papmirid,"PAT",1),del,1),patno=..ConvertPatNo(patno)
 s patname=$p(^PAPER(papmirid,"ALL"),del,1)
 s patname2=$p(^PAPER(papmirid,"ALL"),del,2)
 s sexrid=$p(^PAPER(papmirid,"ALL"),del,7)
 S sex=$p(^CT("SEX",sexrid),del,2)
 S telh=$p(^PAPER(papmirid,"PER",1),del,11)
 s meddiscdate=""
 s finaldiscdate=$p(^PAADM(AdmId),"^",17)
 s birthday=$P(^PAPER(papmirid,"ALL"),del,6)
 s age=$e($zd($H,8),1,4)-$e($zd(birthday,8),1,4)
 s birthday=$zd(birthday,3)
 s admdate=$p(^PAADM(AdmId),del,6),admdate=$zd(admdate,3)
 s admlocrid=$p(^PAADM(AdmId),del,4)
 s admloc=""
 s WardCode="",CtLocCode="",WardCode="",insutype=""
 s:$d(^CTLOC(admlocrid)) admloc=$P(^CTLOC(admlocrid),del,2),AdmLocCode=$P(^CTLOC(admlocrid),del,1)
 S insutype=$p(^PAADM(AdmId,1),del,6)
 if insutype'="" d
 .s insutype=$p(^PAC("SUBT",insutype),del,2)
 s pattype=$p(^PAADM(AdmId,1),del,7)
 s VisitStatu=$p(^PAADM(AdmId),del,20)
 i pattype'="" d 
 .S pattype=+pattype
 .i $d(^PAC("ADMREA",pattype))  d 
 ..s pattype=$p(^PAC("ADMREA",pattype),del,1)
 .e  d
 ..s pattype=""
 e  s pattype=""
 S doctor=$p(^PAADM(AdmId),del,9) 
 i doctor'="" D
 .s DoctorCode=$p($g(^CTPCP(doctor,1)),del,1)
 .s doctor=$p($g(^CTPCP(doctor,1)),del,2)
 E  D
 .s doctor=""
 S wardrid=$p(^PAADM(AdmId),del,70)
 I $g(wardrid)="" d 
 .s ward="",room="",bed=""
 e  d
 .s ward=$p(^PAWARD(wardrid),del,2)
 .s WardCodeDr=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(ward),""))
 .IF $G(WardCodeDr)="" S WardCode=""
 .ELSE  s WardCode=$p(^CTLOC(WardCodeDr),del,1)
 .s roomrid=$p(^PAADM(AdmId),del,69)
 .If roomrid="" Set room=""
 .Else  Set room=$p($g(^PAROOM(roomrid)),del,1)
 .s bedrid=$p(^PAADM(AdmId),del,73)
 .If bedrid="" Do
 ..Set bed=""
 .else  Do
 ..IF '$D(^PAWARD($p(bedrid,"||",1),"BED",$p(bedrid,"||",2))) s bed=""
 ..else  s bed=$p(^PAWARD($p(bedrid,"||",1),"BED",$p(bedrid,"||",2)),del,1)
 s retstr=insutype_del_AdmLocCode_del_admloc_del_pattype_del_admdate_del_""_del_WardCode
 s retstr=retstr_del_$g(ward)_del_$g(room)_del_$g(bed)_del_$g(DoctorCode)_del_doctor_del_VisitStatu_del_meddiscdate_del_finaldiscdate_del_$g(AdmType)
 ;医保类型 科室代码 科室名称 病人类型 就诊日期 “” 病区代码
 ;  1       2         3        4        5       6   7
 ;病区名称  房间  床位  医生代码  医生名称 就诊壮态 医疗结算 最终结算  就诊类型
 ;8          9      10   11        12       13          14      15        16

 q retstr
}

/// 根据ADMID查找患者的诊断信息
ClassMethod GetDiagByAdm(AdmId As %String) As %String
{
	s RetStr=""
	q:(($g(AdmId)="")!('$d(^PAADM(AdmId)))) RetStr
	s del="^"
	s MRAdmDr=$p(^PAADM(AdmId),"^",61)
	s MRDescStr=""
	s childsub=0
	f  s childsub=$o(^MR(MRAdmDr,"DIA",childsub))   q:childsub=""  d
	.s mrciddx=$p(^MR(MRAdmDr,"DIA",childsub),"^",1)
	.s MRDIADesc=$g(^MR(MRAdmDr,"DIA",childsub,"DES",1))
	.s mrciddxDesc=$p(^MRC("ID",mrciddx),"^",2)
	.i mrciddxDesc="自定义诊断"  s mrciddxDesc=MRDIADesc
	.e  s mrciddxDesc=mrciddxDesc_MRDIADesc
	.i MRDescStr=""  s MRDescStr=mrciddxDesc
	.e  s MRDescStr=MRDescStr_","_mrciddxDesc
	q MRDescStr
}

/// 根据ROWID取病人信息
ClassMethod GetPatInfo(PapmiId As %String) As %String
{
	SET del="&",del="^",retstr=""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""
 q:'$d(^PAPER(PapmiId)) 0
 s patno=$p(^PAPER(PapmiId,"PAT",1),del,1)
 S name=$p(^PAPER(PapmiId,"ALL"),del,1)
	s name2=$p(^PAPER(PapmiId,"ALL"),del,2)
 s sexdr=$p(^PAPER(PapmiId,"ALL"),del,7) 
 s:sexdr'="" sex=$p(^CT("SEX",sexdr),del,2)
 s:sexdr="" sex=""
 s birthday=$p(^PAPER(PapmiId,"ALL"),del,6),birthday=$zd(birthday,3)
 s patid=$p(^PAPER(PapmiId,"ALL"),del,9)
 s active=$p(^PAPER(PapmiId,"PAT",1),del,6)
 S active=$select($g(active)="":"Yes",active="Y":"Yes",active="N":"No")
 S telo=$p(^PAPER(PapmiId,"PER",1),del,9)
 s telh=$p(^PAPER(PapmiId,"PER",1),del,11)
 S address=""
 s occupation=$p(^PAPER(PapmiId,"PAT",1),del,8)
 if $g(occupation)'="" s occupation=$p(^PAC("PCAT",occupation),del,2)
 s workunit=""
 s:$d(^PAPER(PapmiId,"PER","ADD",0)) workunit=$g(^PAPER(PapmiId,"PER","ADD",1))
 s retstr=PapmiId_del_patno_del_name_del_name2_del_sex_del_birthday_del_patid_del_active_del_telo_del_telh_del_workunit
 ;		     1			2	      	3		4		 5		    6		  	7		8			9		10  	11			10		    11			
 S retstr=retstr_del_occupation
 ;	        			    12
 q retstr
}

/// 根据登记号取病人信息
ClassMethod GetPatInfoByPatNo(PatNo As %String) As %String
{
 	S PatNo=..ConvertPatNo(PatNo)
 	q:$g(PatNo)="" ""
 	SET del="^"
 	s i=1,j=1,PapmiId=0
 	S PapmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),PapmiId)) 
 	q:PapmiId'="" ..GetPatInfo(PapmiId)
 	q:PapmiId="" ""
}

ClassMethod GetPatInfoByAdmId(AdmId As %String) As %String
{
	s del="^",RetStr=""
	q:(($g(AdmId)="")!('$d(^PAADM(AdmId)))) RetStr
	s PapmiId=$p(^PAADM(AdmId),del,1)
	q:'$d(^PAPER(PapmiId)) RetStr
	s RetStr=..GetPatInfo(PapmiId)
	q RetStr
}

}
