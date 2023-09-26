Class web.DHCFBPat Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod ConvertPatNo(PatNo As %String) As %String
{
	s PatNo=$tr(PatNo," ")
	s PatLen=$p(^CF("PATCF",1,3),"^",5)
	S:PatLen="" PatLen=8
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
 s patstatus=$p(^PAADM(AdmId),del,20)
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
 s retstr=retstr_del_$g(ward)_del_$g(room)_del_$g(bed)_del_$g(DoctorCode)_del_doctor_del_patstatus_del_meddiscdate_del_finaldiscdate_del_$g(AdmType)
 ;patno patname patname2_sex_age_pattype_admloc_"就诊日期"_admdate_ward_room_bed_doctor_patstatus_insutype_birthday_telh
 ;  1      2       3      4   5       6    7               8       9   10   11   12      13       14       15       16
 ;meddiscdate finaldiscdate
 ;  17           18  
 q retstr
}

ClassMethod GetPatAdm(repid As %Integer = 0, startdate As %String = "", enddate As %String = "", patno As %String = "", admtype As %String = "") As %Integer
{
 s patinfo=..GetPatInfoByPatNo(patno)
 k TPLIST
 s del="^",i=1
 s dateflag=0,admdate="",admid="",admtype1="",admtype2=""
 s patrid=$p(patinfo,del,1)
 q:patrid="" 0
 IF admtype="" s admtype="I",admtype1="I"
 if (($g(startdate)'="") & ($g(enddate)'="")) d
 .s startdate=$zdh(startdate,3),enddate=$zdh(enddate,3)
 .S dateflag=1
 f  s admid=$o(^PAPERdr(patrid,"ADM",admtype,admid),-1) s:((admtype="I") & (admid="") & (admtype1="I")) admtype="O",admid=9999999999999999 q:admid=""  d
 .q:((admid=9999999999999999)& (admtype="O"))
 .s admdate=$p(^PAADM(admid),del,6)
 .q:((dateflag=1) & ((admdate<startdate) ! (admdate>enddate)))
 .s admstatus=$p(^PAADM(admid),del,20)
 .q:admstatus="C"
 .s admdate=$zd(admdate,3),admtype2=$p(^PAADM(admid),del,2) 
 .if admtype2="O" S admtype2="门诊"
 .if admtype2="I" s admtype2="住院"
 .s pattype=$p(^PAADM(admid,1),del,7)
 .i pattype'="" d 
 ..S pattype=+pattype
 ..i $d(^PAC("ADMREA",pattype))  d 
 ...s pattype=$p(^PAC("ADMREA",pattype),del,2)
 ..e  d
 ...s pattype=""
 .e  s pattype=""
 .S admloc=$p(^PAADM(admid),del,4),admloc=$p($p(^CTLOC(admloc),del,2),"-",2)
 .;s TPLIST(i)=admid_del_admtype2_del_admdate_del_admloc_del_pattype
 .s ^CacheTempFHQ(repid,i)=admid_del_admtype2_del_admdate_del_admloc_del_pattype
 .s i=i+1
 Q i-1
}

ClassMethod GetPatInfo(rid As %String) As %String
{
	SET del="&",del="^",retstr=""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""_del_""
 q:'$d(^PAPER(rid)) 0
 s patno=$p(^PAPER(rid,"PAT",1),del,1)
 S name=$p(^PAPER(rid,"ALL"),del,1)
	s name2=$p(^PAPER(rid,"ALL"),del,2)
 s sexdr=$p(^PAPER(rid,"ALL"),del,7) 
 s:sexdr'="" sex=$p(^CT("SEX",sexdr),del,2)
 s:sexdr="" sex=""
 s birthday=$p(^PAPER(rid,"ALL"),del,6),birthday=$zd(birthday,3)
 s patid=$p(^PAPER(rid,"ALL"),del,9)
 s active=$p(^PAPER(rid,"PAT",1),del,6)
 S active=$select($g(active)="":"Yes",active="Y":"Yes",active="N":"No")
 S telo=$p(^PAPER(rid,"PER",1),del,9)
 s telh=$p(^PAPER(rid,"PER",1),del,11)
 S address=""
 s occupation=$p(^PAPER(rid,"PAT",1),del,8)
 if $g(occupation)'="" s occupation=$p(^PAC("PCAT",occupation),del,2)
 s workunit=""
 s:$d(^PAPER(rid,"PER","ADD",0)) workunit=$g(^PAPER(rid,"PER","ADD",1))
 s retstr=rid_del_patno_del_name_del_name2_del_sex_del_birthday_del_patid_del_active_del_telo_del_telh_del_workunit
 ;		     1			2	      	3			    4		      5		    6		        	7				8					  9				10		    11			
 S retstr=retstr_del_occupation
 ;	        			    12
 q retstr
}

ClassMethod GetPatInfoByPatNo(PatNo As %String) As %String
{
	;N (PatNo,MPLIST,TPLIST)
	s PatNo=$tr(PatNo," ")
	s PatLen=$p(^CF("PATCF",1,3),"^",5)
	S:PatLen="" PatLen=10
 S PatNo=$tr($justify(PatNo,PatLen,0)," ","0")
 q:$g(PatNo)="" ""
 SET del="^"
 s i=1,j=1,rid=0
 S rid=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),rid)) 
 q:rid'="" ..GetPatInfo(rid)
 q:rid="" ""
}

}
