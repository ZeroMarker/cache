/// 名称: DHCMed.EPDService.FluStaticSrv
/// 描述: 统计流感样就诊情况
Class DHCMed.EPDService.FluStaticSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2020-04-17
/// Description:  查询流感样
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.FluStaticSrv","FluSatic","","","2019-02-01","2019-02-17")
Query FluSatic(aHospID As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "Week:%String,AdmDate:%String,LocID:%String,LocDesc:%String,AdmCount:%String,Flu1Count:%String,Flu2Count:%String,Flu3Count:%String,Flu4Count:%String,Flu5Count:%String") [ SqlProc ]
{
}

ClassMethod FluSaticExecute(ByRef qHandle As %Binary, aHospID As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set StandardDate = $zdh("2001-01-01",3)  //选择合适的周一作为起始日期 
	Set StatDate="",EndDate=""
	Set:aDateFrom["-" StatDate=$p(aDateFrom,"-",1)_"-01-01"
	Set:aDateFrom["/" StatDate=$p(aDateFrom,"/",3)_"-01-01"	
	Set:aDateTo["-" EndDate=$p(aDateTo,"-",1)_"-01-01"
	Set:aDateTo["/" EndDate=$p(aDateTo,"/",3)_"-01-01"	
	Quit:(StatDate="")||(EndDate="") $$$OK   
    Set StatDate = $zdh(StatDate,3)
    Set EndDate = $zdh(EndDate,3)
    
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(StandardDate>aDateFrom)||(StandardDate>aDateTo) $$$OK
  
    Kill ^TMP($zn,$j,"FluSatic")
    	
	//门、急诊患者
	For xDate=aDateFrom:1:aDateTo {		
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Set PatientID=$p(AdmInfo,"^",1) 
			Continue:($p(AdmInfo,"^",2)'="O")&&($p(AdmInfo,"^",2)'="E")      //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
		
			Set LocID=+$p(AdmInfo,"^",4)
			Continue:(aLocID'="")&&(aLocID'=LocID)
			If aHospID'="" {
				Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospID)
				Continue:flg<1
			}
			
			Set AgeGroup =1
			Set Age = ##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,xPaadm,xDate,"")
			If (Age'["岁") {
				Set AgeGroup =1
			}Else {
				Set:(+Age<5) AgeGroup =1
				Set:(+Age>4)&&(+Age<15) AgeGroup =2
				Set:(+Age>14)&&(+Age<25) AgeGroup =3
				Set:(+Age>24)&&(+Age<60) AgeGroup =4
				Set:(+Age>=60) AgeGroup =5
			}
			
			Set ILIFlag=$p($g(^PAADM(xPaadm,"DHC")),"^",13)
			
			Set num=+$g(^TMP($zn,$j,"FluSatic",LocID,xDate,"PatAdm"))
			Set ^TMP($zn,$j,"FluSatic",LocID,xDate,"PatAdm")=num+1
			Set ^TMP($zn,$j,"FluSatic",LocID,xDate,"PatAdm",xPaadm) = ""

			If ILIFlag="Y" { // 诊断录入界面下，勾选病例样选框后，该global生效
				Set num=+$g(^TMP($zn,$j,"FluSatic",LocID,xDate,AgeGroup,"IsFlu"))
				Set ^TMP($zn,$j,"FluSatic",LocID,xDate,AgeGroup,"IsFlu")=num+1
				Set ^TMP($zn,$j,"FluSatic",LocID,xDate,AgeGroup,"IsFlu",xPaadm)=""
			}										
		}
	}
	
	Set xLocID = ""
	For {
		Set xLocID = $o(^TMP($zn,$j,"FluSatic",xLocID))
		Quit:xLocID=""
		
		Set LocDesc=$p(^CTLOC(xLocID),"^",2)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			
		For xDate=aDateFrom:1:aDateTo {          //让日期连续
		    If (xDate>=EndDate) {   //时间段跨年
		    	Set Week =(xDate-EndDate+((EndDate-StandardDate)#7))\7+1
		    }Else {
		   		Set Week =(xDate-StatDate+((StatDate-StandardDate)#7))\7+1  //一年中的第几周
		    }
           	Set AdmDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(xDate)   
           	
	        If '$d(^TMP($zn,$j,"FluSatic",xLocID,xDate)) {              
		       	Set Data=$lb(Week,AdmDate,xLocID,LocDesc,0,0,0,0,0,0)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
	        }else {
		     	Set AdmCount = +$g(^TMP($zn,$j,"FluSatic",xLocID,xDate,"PatAdm"))
				Set Flu1Count = +$g(^TMP($zn,$j,"FluSatic",xLocID,xDate,1,"IsFlu"))
				Set Flu2Count = +$g(^TMP($zn,$j,"FluSatic",xLocID,xDate,2,"IsFlu"))
				Set Flu3Count = +$g(^TMP($zn,$j,"FluSatic",xLocID,xDate,3,"IsFlu"))
				Set Flu4Count = +$g(^TMP($zn,$j,"FluSatic",xLocID,xDate,4,"IsFlu"))
				Set Flu5Count = +$g(^TMP($zn,$j,"FluSatic",xLocID,xDate,5,"IsFlu"))
			    
				Set Data=$lb(Week,AdmDate,xLocID,LocDesc,AdmCount,Flu1Count,Flu2Count,Flu3Count,Flu4Count,Flu5Count)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
	        }
		}
	}

    Kill ^TMP($zn,$j,"FluSatic")
	Quit $$$OK
}

ClassMethod FluSaticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FluSaticExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FluSaticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FluSaticExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
