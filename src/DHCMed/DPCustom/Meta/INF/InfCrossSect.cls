/// Name：DHCMed.DPCustom.Meta.INF.InfCrossSect
/// 描述: 抽取现患率信息
/// 编写者：zhufei
/// 编写日期: 2013-11-28
Class DHCMed.DPCustom.Meta.INF.InfCrossSect Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// 抽取现患率信息
/// FromDate:填报告开始日期
/// ToDate：填报告结束日期
/// d ##class(DHCMed.DPCustom.Meta.INF.InfCrossSect).ExtractData(arg1,arg2)
ClassMethod ExtractData(FromDate As %Date, ToDate As %Date) As %String
{
	n (FromDate,ToDate)
	Set:FromDate["-" FromDate=$zdh(FromDate, 3)         //日期格式转换
	Set:FromDate["/" FromDate=$zdh(FromDate, 4)
	Set:ToDate["-" ToDate=$zdh(ToDate, 3)
	Set:ToDate["/" ToDate=$zdh(ToDate, 4)
	quit:(FromDate="")||(ToDate="") $$$OK
	set HDMDate=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("INFHDMResDate")
   	set EpisodeID=""
   	for {
	   	set EpisodeID=$o(^DHCMed.NINF.Aim.PatientAdmToHDM("IndexEpisodeID",EpisodeID))
	   	Quit:EpisodeID=""
	   	set PaadmInitID=$o(^DHCMed.NINF.Aim.PatientAdmToHDM("IndexEpisodeID",EpisodeID,""))
	   	set PaadmInitStr=$g(^DHCMed.NINF.Aim.PatientAdmToHDM(PaadmInitID))
	   	set LocID=$li(PaadmInitStr,4)
	   	set WardID=$li(PaadmInitStr,5)
	   
	   
	   	s (Checked,DiseasKind,IfHosInf,IfAnti,AntiAim,AntiUnit,AntiLab,LabTime,HasOpr,OprAnti,OprAntiTime,CutType,CutAnti,CutAntiTime,DJMCG,MNDCG,QGCGQK,HXJ,JMSY,HosInfPos,HosInfObj,PosCount,ObjCount,CheckUser,checkDate)=""
	   	//continue:'$d(^DHCMed.CR.ReportI("IndexAdmProj"," 2"," "_EpisodeID))
	   	
	   	if ($d(^DHCMed.CR.ReportI("IndexAdmProj"," 2"," "_EpisodeID))){
		   	set CrRepID=$o(^DHCMed.CR.ReportI("IndexAdmProj"," 2"," "_EpisodeID,""),-1)
		   	continue:CrRepID=""
		   	set CRObj=##class(DHCMed.CR.Report).GetById(CrRepID)
		   	Continue:(CRObj.RepStatus="删除")||(CRObj.RepStatus="退回")
		   	set CrRepStr=$g(^DHCMed.CR.ReportD(CrRepID))
		   	set RepDate=$li(CrRepStr,7)
		   	continue:(RepDate>ToDate)||(RepDate<FromDate)
		   	set HDMID=$o(^DHCMed.NINF.Aim.HDMI("CRReportDR"," "_CrRepID,""),-1)
		   	continue:HDMID=""
		   	set Checked="1"
		   	set objHDM=##class(DHCMed.NINF.Aim.HDM).GetObjById(HDMID)
		   	set HasOpr =objHDM.HasOpr
			set:HasOpr="" HasOpr="否"
			
			set DiseasKind  = objHDM.DiseasKind  		//系统疾病
			set HasOpr=$s(HasOpr="是":1,HasOpr="否":0,1:0)  //是否手术
		   		
		   	set CutType =objHDM.CutType
			set CutType=$s(CutType="I类":"1",CutType="II类":"2",CutType="III类":"3",CutType="IV类":"4",CutType="无":"0",1:"")
			
			
			set IfInf = objHDM.IfInf
			set IfInf=$s(IfInf="是":1,IfInf="否":0,1:0)  //是否感染
			
			set InfType=objHDM.InfType
			
			
			set HosInfPos =objHDM.HosInfPos
			set (PosInd,HPosLen)=""
		
			//医院感染信息
			set InfPosH1=$p(HosInfPos,"#",1)  //部位数1
			set InfPosH2=$p(HosInfPos,"#",2)  //部位数2
			set InfPosH3=$p(HosInfPos,"#",3)  //部位数3
			
			set InfPyListH1=$p(HosInfObj,"#",1)  //病原体1
			set InfPyListH2=$p(HosInfObj,"#",2)  //病原体2
			set InfPyListH3=$p(HosInfObj,"#",3)  //病原体3
			
			//社区感染信息
			set InfPosS1=$p(SocInfPos,"#",1)  //部位数1
			set InfPosS2=$p(SocInfPos,"#",2)  //部位数2
			set InfPosS3=$p(SocInfPos,"#",3)  //部位数3
			
			set InfPyListS1=$p(SocInfObj,"#",1)  //病原体1
			set InfPyListS2=$p(SocInfObj,"#",2)  //病原体2
			set InfPyListS3=$p(SocInfObj,"#",3)  //病原体3
			
		
			set MNDCG =objHDM.MNDCG ;泌尿道
			set:MNDCG="" MNDCG="否"
			set MNDCG=$s(MNDCG="是":1,MNDCG="否":0,1:0)  //是否
			
			set DJMCG =objHDM.DJMCG  ;动静脉
			set:DJMCG="" DJMCG="否"
			set DJMCG=$s(DJMCG="是":1,DJMCG="否":0,1:0)  //是否
			
			set QGCGQK =objHDM.QGCGQK ;气管插管
			set QGCGQK=$s(QGCGQK="是":1,QGCGQK="否":0,1:0)  //是否
			
			set HXJ =objHDM.HXJ   ;呼吸机
			set:HXJ="" HXJ="否"
			set HXJ=$s(HXJ="是":1,HXJ="否":0,1:0)  //是否
			
			set XYTX =objHDM.XYTX  	;血液透析
			set:XYTX="" JMSY="否"
			set XYTX=$s(XYTX="是":1,XYTX="否":0,1:0)  //是否
			
			
			set IfAnti = objHDM.IfAnti
			set IfAnti=$s(IfAnti="是":1,IfAnti="否":0,1:0)  //是否
			
			set AntiAim =objHDM.AntiAim
			set AntiUnit =objHDM.AntiUnit
			set AntiLab =objHDM.AntiLab
			
			Set mainstr=""_"^"_EpisodeID_"^"_"CS"_"^"_"CS-CSS-REP"_"^"_RepDate_"^"_CrRepID_"^"_CrRepID_"^"_""_"^"_"1"_"^"_+$h_"^"_$p($h,",",2)_"^"_""
			Set MainID=##Class(DHCMed.DP.Meta.ActMain).Update(mainstr)
			q:MainID<=0
			//“第几次调查”用横断面日期-由于没有建立横断面调查记录表
			Set SubStr=""_"^"_MainID_"^"_"CS-CSS-REP"_"^"_CrRepID_"^"_HDMDate_"^"_LocID_"^"_WardID_"^"_DiseasKind_"^"_HasOpr_"^"_CutType_"^"_IfInf_"^"_InfType_"^"_InfPosH1_"^"_InfPosH2_"^"_InfPosH3_"^"_InfPyListH1_"^"_InfPyListH2_"^"_InfPyListH3_"^"_InfPosS1_"^"_InfPosS2_"^"_InfPosS3_"^"_InfPyListS1_"^"_InfPyListS2_"^"_InfPyListS3_"^"_MNDCG_"^"_""_"^"_DJMCG_"^"_""_"^"_QGCGQK_"^"_""_"^"_HXJ_"^"_""_"^"_XYTX_"^"_""_"^"_IfAnti_"^"_AntiAim_"^"_AntiUnit_"^"_AntiLab
			Set SubID=##Class(DHCMed.DP.Meta.InfCrossSect).Update(SubStr)	
	   	}


}
}

}
