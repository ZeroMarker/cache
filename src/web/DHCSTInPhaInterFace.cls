Import sqluser

Class web.DHCSTInPhaInterFace Extends (%Library.Persistent, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 337;

ClassMethod PutMessagePharmacy(type, rowid, checkflag = "")
{
 ///description:华西接口,发退药传数量至老HIS  
 ///creator:lq  08-11-05
 ;type=1 rowid是发药表的rowid
 ;type=2 rowid是退药表的rowid
 ;checkflag  重发时选中的某一项的惟一值
 ;w ##class(web.DHCSTInPhaInterFace).PutMessagePharmacy(1,329)
 s pid=..Pid()
 k ^TMP(pid,"dhcpha")
 s retstr=""

 i type="1" d
 .s retstr=..CreaPhaDataHX(rowid,pid,$g(checkflag))
 ;
 i type="2" d
 .s rcnt=$l(rowid,"^")
 .f r=1:1:rcnt d
 ..s newrowid=$p(rowid,"^",r)
 ..s retstr=..CreaPhaRetDataHX(newrowid,pid,$g(checkflag))
 ;

 
 q:'$d(^TMP(pid,"dhcpha","main")) -1
 ;
 s adm=""
 f  s adm=$o(^TMP(pid,"dhcpha","main",adm)) q:adm=""  d
 .s maininfo=^TMP(pid,"dhcpha","main",adm)
 .s subinfo=^TMP(pid,"dhcpha","sub",adm)
 .s info=maininfo_$c(2)_subinfo
 .s xmlstr=..TransXMLFrStr(info)
 .;w !,xmlstr
 .;s ^lq(adm)=xmlstr
 .s soap=##class(web.PhaServiceSoap).%New()
 .d soap.Phamarcy(xmlstr)
 k ^TMP(pid,"dhcpha")
 q 0
}

ClassMethod TransXMLFrStr(AllString)
{
	n (AllString)
 s MainString=$p(AllString,$c(2),1)
 s SubString=$p(AllString,$c(2),2)
 ;
 s disploc=$p(MainString,"^",1)
 s prtdate=$p(MainString,"^",2)
 s patno=$p(MainString,"^",3)
 s patname=$p(MainString,"^",4)
 s patsex=$p(MainString,"^",5)
 s patage=$p(MainString,"^",6)
 s pattype=$p(MainString,"^",7)
 s prescno=$p(MainString,"^",8)
 s presctype=$p(MainString,"^",9)
 s admlocdesc=$p(MainString,"^",10)
 s doctor=$p(MainString,"^",11)
 s doctor=$e(doctor,0,5)
 s fyuser=$p(MainString,"^",12)
 s prtuser=$p(MainString,"^",13)
 s prtcode=$p(MainString,"^",14)
 s dispdate=$p(MainString,"^",15)
 s mangagetype=$p(MainString,"^",16)
 k obj,objsub
 set obj=##class(web.DHCInPhSendMeg).%New()
 s obj.Pharmacy=disploc
 s obj.PrtDate=prtdate
 s obj.PatNo=patno ;pmino
 s obj.PatName=patname
 s obj.PatSex=patsex
 s obj.PatAge=patage
 s obj.PatType=pattype
 s obj.PrescNo=prescno
 s obj.PrescType=presctype
 s obj.PatAdmLoc=admlocdesc
 s obj.PatDoctor=doctor
 s obj.Chemist=fyuser
 s obj.Cashier=prtuser
 s obj.BillNo=prtcode
 s obj.DispDate=dispdate
 s obj.ManageType=mangagetype
 s m=$l(SubString,$c(1))
 f i=1:1:m  d
  .set objsub=##class(web.DHCInPhSendMegSub).%New()
  .s lrowstr="",phcode="",phqty=0,phprice=0,payscale="",bursary=""
  .s lrowstr=$p(SubString,$c(1),i)
  .s phcode=$p(lrowstr,"^",1)
  .s phqty=$p(lrowstr,"^",2)
  .s phprice=$p(lrowstr,"^",3)
  .s payscale=$p(lrowstr,"^",4)
  .s bursary=$p(lrowstr,"^",5)
  .s objsub.PhCode=phcode
  .s objsub.PhQty=phqty
  .s objsub.PhPrice=phprice
  .s objsub.SelfPayScale=payscale
  .s objsub.Bursary=bursary
  .d obj.PhInformation.Insert(objsub)
 set sc=obj.XMLExportToString(.result)
 quit result
}

ClassMethod CreaPhaDataHX(phac, pid, checkflag) As %String
{
 //根据发药单rowid生成XML数据
 
 n (phac,pid,checkflag)
 s nn=0
 s phalocdr=$p($g(^DHCPHAC(phac)),"^",1)
 s loc=$p($g(^CTLOC(phalocdr)),"^",2)       ;发药部门
 s phauserid=$p(^DHCPHAC(phac),"^",5) 
 s phauser=$p(^SSU("SSUSR",phauserid),"^",2) ;发药人员
 s phadate=$p(^DHCPHAC(phac),"^",2)
 i phadate'="" s phadate=$zd(phadate,3)   ;发药日期 
 s phatime=$p(^DHCPHAC(phac),"^",3)
 i phatime'="" s phatime=$zt(phatime,1)   ;发药时间
 s dispno=$p(^DHCPHAC(phac),"^",14)
 s type=$p(^DHCPHAC(phac),"^",12)
 s type="普通处方"
 i type="DMY" s type="毒麻处方"
 i type="JY" s type="一类精神"
 s mangagetype="B"
 s ch=0
 f   s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
 .s phaci=phac_"||"_ch
 .s oeori=$p(^DHCPHAC(phac,"I",ch),"^",7)
 .s dispqty=$P(^DHCPHAC(phac,"I",ch),"^",6)  ;数量
 .s presno=$P(^DHCPHAC(phac,"I",ch),"^",5)   ;处方号
 .i presno="" s presno="I08080899999" 
 .;s presno=presno_phac ;处方号+发药主表rowid
 .s detp=$p(^DHCPHAC(phac,"I",ch),"^",11)
 .s deptsn=""
 .i detp'="" s deptsn=$P($g(^CTLOC(detp)),"^",1)   ;科室编码
 .s ord=$p(oeori,"||",1)
 .s chl=$p(oeori,"||",2)
 .s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori) ;开单医生
 .i $f(doctor,"(") s doctor=$p(doctor,"(")
 .s arcim=$p(^OEORD(ord,"I",chl,1),"^",2) ;医嘱项rowid
 .s inci=..GetINCI(arcim)
 .s incicode=$p(^INCI(inci,1),"^",1) ;代码
 .s price=$p(^DHCPHAC(phac,"I",ch),"^",9) ;单价
 .s ord=+oeori
 .s adm=$P(^OEORD(ord),"^",1)
 .s data1=..PaInfo(adm)
 .s patno=$p(data1,"^",1)
 .s patname=$p(data1,"^",3)
 .s patsex=$p(data1,"^",4)
 .s patage=$p(data1,"^",5)
 .s pattype=$p(data1,"^",9)
 .;s patloc=$p(data1,"^",10)
 .s patloc=$p($G(^DHCPHAC(phac,"I",ch)),"^",11)
 .s index="I"_dispno_adm_patloc   //消息的惟一值
 .q:(checkflag'="")&(index'=checkflag) //重发时过滤多余消息
 .
 .s retamain=loc_"^"_""_"^"_patno_"^"_patname_"^"_patsex_"^"_patage_"^"_pattype_"^"_index_"^"_type_"^"_deptsn_"^"_doctor_"^"_phauser_"^"_""_"^"_""_"^"_phadate_" "_phatime_"^"_mangagetype
 .s retsub=incicode_"^"_dispqty_"^"_price_"^"_"50"_"^"_"1"
 .;i '$d(^TMP(pid,"dhcpha","main",adm,presno)) d 
 .;.s ^TMP(pid,"dhcpha","main",adm,presno)=retamain
 .;.s nn=nn+1
 .;i $d(^TMP(pid,"dhcpha","sub",adm,presno)) s ^TMP(pid,"dhcpha","sub",adm,presno)=^TMP(pid,"dhcpha","sub",adm,presno)_$c(1)_retsub
 .;e  s ^TMP(pid,"dhcpha","sub",adm,presno)=retsub
 .
 .i '$d(^TMP(pid,"dhcpha","main",index)) d
 ..s ^TMP(pid,"dhcpha","main",index)=retamain
 ..s nn=nn+1
 .i '$d(^TMP(pid,"dhcpha","sub",index)) d
 ..s ^TMP(pid,"dhcpha","sub",index)=retsub
 .e  d
 ..s ^TMP(pid,"dhcpha","sub",index)=^TMP(pid,"dhcpha","sub",index)_$c(1)_retsub
 .
 q nn_"^"_pid
}

ClassMethod CreaPhaRetDataHX(pharet, pid, checkflag) As %String
{
	///根据退药单rowid生成XML数据
	n (pharet,pid,checkflag)
	s nn=0
    s phacidr=$p(^PHARET(pharet),"^",23)
    s phac=+phacidr
    s type=$p(^DHCPHAC(phac),"^",12)
    s type="普通处方"
    i type="DMY" s type="毒麻处方"
    i type="JY" s type="一类精神"
    s mangagetype="B"
	s phalocdr=$p(^PHARET(pharet),"^",8) 
	s loc=$p(^CTLOC(phalocdr),"^",2)       ;退药部门
	s adm=$p(^PHARET(pharet),"^",10)
	s data1=..PaInfo(adm)
    s patno=$p(data1,"^",1)
    s patname=$p(data1,"^",3)
    s patsex=$p(data1,"^",4)
    s patage=$p(data1,"^",5)
    s pattype=$p(data1,"^",9)
    ;s patloc=$p(data1,"^",10)
    s patloc=$p(^PHARET(pharet),"^",7)
    s retno=$p(^PHARET(pharet),"^",16)
    s presno=$p(^PHARET(pharet),"^",11)
    i presno="" s presno="I08080899999"  
    s phadr=$p(^PHARET(pharet),"^",23)
    s phac=+phadr
    s dispno=$p(^DHCPHAC(phac),"^",14)
    ;s presno="-"_presno_phadr_retno                 ;退药加 "-" 处方号_发药主表rowid
    s detp=$p(^PHARET(pharet),"^",9)
    s deptsn=""
    i detp'="" s deptsn=$P($g(^CTLOC(detp)),"^",1)   ;科室编码
    s oeori=$p(^PHARET(pharet),"^",5)
    s ord=$p(oeori,"||",1)
    s chl=$p(oeori,"||",2)
    s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori) ;开单医生
    i $f(doctor,"(") s doctor=$p(doctor,"(")
    s retuserdr=$p(^PHARET(pharet),"^",3)
    s retuser=$p(^SSU("SSUSR",retuserdr),"^",2) ;退药人员
    s retdate=$p(^PHARET(pharet),"^",1)
    i retdate'="" s retdate=$zd(retdate,3)  ;退药日期
    s rettime=$p(^PHARET(pharet),"^",2)
    i rettime'="" s rettime=$zt(rettime,1)
    s arcim=$p(^OEORD(ord,"I",chl,1),"^",2) ;医嘱项rowid
    s inci=..GetINCI(arcim)
    s incicode=$p(^INCI(inci,1),"^",1) ;代码 
    s qty=$p(^PHARET(pharet),"^",12)
    s price=$p(^PHARET(pharet),"^",13)
    s index="-"_"I"_dispno_adm_patloc_retno //消息的惟一值
    q:(checkflag'="")&(index'=("-"_checkflag)) 0
	s retamain=loc_"^"_""_"^"_patno_"^"_patname_"^"_patsex_"^"_patage_"^"_pattype_"^"_index_"^"_type_"^"_deptsn_"^"_doctor_"^"_retuser_"^"_""_"^"_""_"^"_retdate_" "_rettime_"^"_mangagetype
    s retsub=incicode_"^"_qty_"^"_price_"^"_"50"_"^"_"1"
    ;i '$d(^TMP(pid,"dhcpha","main",adm,presno)) d
    ;.s ^TMP(pid,"dhcpha","main",adm,presno)=retamain
    ;.s nn=nn+1
    ;i $d(^TMP(pid,"dhcpha","sub",adm,presno)) s ^TMP(pid,"dhcpha","sub",adm,presno)=^TMP(pid,"dhcpha","sub",adm,presno)_$c(1)_retsub
    ;e  s ^TMP(pid,"dhcpha","sub",adm,presno)=retsub
    i '$d(^TMP(pid,"dhcpha","main",index)) d
    .s ^TMP(pid,"dhcpha","main",index)=retamain
    .s nn=nn+1
    i '$d(^TMP(pid,"dhcpha","sub",index)) d
    .s ^TMP(pid,"dhcpha","sub",index)=retsub
    e  d
    .s ^TMP(pid,"dhcpha","sub",index)=^TMP(pid,"dhcpha","sub",index)_$c(1)_retsub 
      
    q nn_"^"_pid
}

ClassMethod Pid() As %String
{
	q $I(^DHCSTPHAHX("send"))
}

ClassMethod PaInfo(adm) As %String
{
 //取病人的相关信息
 n (adm)
 q:adm="" ""
 s papmidr=$p($g(^PAADM(adm)),"^",1) q:papmidr="" ""
 s admtype=$p($g(^PAADM(adm)),"^",2) 
 s pano=$p($g(^PAPER(papmidr,"PAT",1)),"^",1) ;登记号
 s name=$p($g(^PAPER(papmidr,"ALL")),"^",1)
 s sexdr=$p($g(^PAPER(papmidr,"ALL")),"^",7)
 s sex=""
 i sexdr'="" s sex=$p(^CT("SEX",sexdr),"^",2)
 ;s dob=$p($g(^PAPER(papmidr,"ALL")),"^",6)
 ;s age=+$h-dob   ;days of age
 s age=##class(web.DHCSTKUTIL).GetAge(papmidr) ;PA_PatMas PAPMI_RowId 
 s ward=$p($g(^PAADM(adm)),"^",70)
 s bed=$p($g(^PAADM(adm)),"^",73)
 s wardcode="",warddesc="",bedno=""
 i ward'="" s wardcode=$p(^PAWARD(ward),"^",1), warddesc=$p(^PAWARD(ward),"^",2)
 i bed'="" s bedno=$p($g(^PAWARD(+bed,"BED",$P(bed,"||",2))),"^",1)  
 s padocno=$P(^PAPER(papmidr,"PAT",3),"^",4) ;登记号
 s deptdr=$p($g(^PAADM(adm)),"^",4) 
 ;
 s result=pano_"^"_adm_"^"_name_"^"_sex_"^"_age_"^"_wardcode_"^"_warddesc_"^"_bedno_"^"_admtype_"^"_deptdr
 q result
}

ClassMethod GetINCI(arcim As %String) As %String
{
 //根据医嘱项rowid取得库存项目的rowid
 n (arcim)
 s ARCIMsub=$p(arcim,"||",1)
 s ARCIMsub=$p(ARCIMsub,$c(1))
 s INCIrow=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
 q $g(INCIrow)
}

}
