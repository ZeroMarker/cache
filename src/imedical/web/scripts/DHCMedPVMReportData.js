//DHCMedPVMReportData.js
function UpdateCheckPVM(encmeth,MPVMRowid,Status,CheckUsr,CheckDate,CheckTime,Demo){
	//alert(MPVMRowid+"-"+Status+"-"+CheckUsr+"-"+CheckDate+"-"+CheckTime+"-"+Demo);
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,MPVMRowid,Status,CheckUsr,CheckDate,CheckTime,Demo);
		return ret;
		}	
	}

function GetPVMInfoByRowid(encmeth,PVMRowid){
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,PVMRowid);
		if (ret!=""){
			objPVMReport=b_BuildPVMReport(ret);
			}	
		}	
	}
function b_BuildPVMReport(sPVMInfo){
	if (sPVMInfo!=""){
		var objPVMReport=new clsPVMReport("");
		var strFields=sPVMInfo.split(CHR_Up)
		var TempPlist
		objPVMReport.Rowid=strFields[0];                            ///
		objPVMReport.ReportNo=strFields[1];                        ///
		
		objPVMReport.ReportType=b_BuildDicObj(strFields[2]);                 ///
		
		objPVMReport.Status=b_BuildDicObj(strFields[3]);           ///
		
		objPVMReport.INCItmBat=b_BuildINCItmBatObj(strFields[4],strFields[5]);                             ///
		//objEpidemicReport.ICD=b_BuildICD(strFields[5]);  ***               /// 
				
		objPVMReport.ReportQty=strFields[6];             ///
		
		objPVMReport.InStockQty=strFields[7];         ///
		
		objPVMReport.StockQty=strFields[8];               ///
		
		//objPVMReport.Description=b_BuildDicObj(strFields[9]);           ///
		objPVMReport.Description.Desc=strFields[9];
		objPVMReport.ResumeText=strFields[10];        ///
		
		objPVMReport.Opinion=b_BuildDicObj(strFields[11]);             ///
		
		objPVMReport.ReportLocation=b_BuildDicObj(strFields[12]);           ///
		objPVMReport.ReportLocation.Rowid=objPVMReport.ReportLocation.Code;		
		
		objPVMReport.ReportPlace=b_BuildDicObj(strFields[13]);       ///		
		
		objPVMReport.RepUser=b_BuildDicObjWithId(strFields[14]);          ///
		
		objPVMReport.ReportDate=strFields[15];               ///
				
		objPVMReport.ReportTime=strFields[16];           ///
		objPVMReport.CheckUser=b_BuildDicObjWithId(strFields[17]);        ///
		objPVMReport.CheckDate=strFields[18];        ///
		objPVMReport.CheckTime=strFields[19];           ///
		objPVMReport.TEXT1=strFields[20];         ///
		objPVMReport.TEXT2=strFields[21];         ///
		return objPVMReport;
		}
	}
function b_BuildINCItmBatObj(INCIRowid,Instring)		
{
	var objINCIBt=new clsINCItmBat("");
	if(Instring!="")
	{
		var TempPlist1=INCIRowid.split(CHR_Tilted);
		var TempPlist2=Instring.split(CHR_Tilted);
		objINCIBt.Rowid=TempPlist2[0];
		objINCIBt.INCItmName=TempPlist1[1];          
		objINCIBt.INCItmBatNo=TempPlist2[1];   
		objINCIBt.ProComp=TempPlist2[4];          
		objINCIBt.ExpDate=TempPlist2[2];   
		}
		return objINCIBt;
	}
	
function UpdatePVM(encmeth,PVMString){
	if (encmeth!=""&&PVMString!=""){
		var ret=cspRunServerMethod(encmeth,PVMString);
		return ret;
		}
	}
function CheckInfomation(){
	with(objPVMReport){
		if (ReportType.Code=="") { gSetFocus("ReportType"); return false;}
		if (INCItmBat.Rowid=="") { gSetFocus("INCItmBatNo"); return false;}
		//if (ReportQty=="") { gSetFocus("ReportQty"); return false;}
		//if (InStockQty=="") { gSetFocus("InStockQty"); return false;}
		//if (StockQty=="") { gSetFocus("StockQty"); return false;}
		//if (Description.Code=="") { gSetFocus("Description"); return false;}
		if (Opinion.Code=="") { gSetFocus("Opinion"); return false;}
		if (ReportPlace.Code=="") { gSetFocus("ReportPlace"); return false;}
		}
	var INCItmID=objPVMReport.INCItmBat.Rowid.split("||");
	if(INCItmID[0]!=gGetObjValue("INCItmID"))
	{
		gSetFocus("INCItmBatNo");return false;
		}
	return true;
	}

function BuildPVMReport(){
	var objTMPPVMReport=new clsPVMReport("");
	with(objTMPPVMReport){
		Rowid=gGetObjValue("MPVMRowid");
	    ReportType.Desc=gGetObjValue("ReportType");
	    ReportType.Code=gGetObjValue("ReportTypeCode");
	    Status.Desc=gGetObjValue("ReportStatus");
	    Status.Code=gGetObjValue("ReportStatusCode");
	    INCItmBat.Rowid=gGetObjValue("INCItmBatID");
	    INCItmBat.INCItmName=gGetObjValue("INCItmNa");
	    INCItmBat.INCItmBatNo=gGetObjValue("INCItmBatNo");
        INCItmBat.ProComp=gGetObjValue("ProComp");
        INCItmBat.ExpDate=gGetObjValue("ExpDate");
        ReportQty=gGetObjValue("ReportQty");
        InStockQty=gGetObjValue("InStockQty");
	    StockQty=gGetObjValue("StockQty");
	    Description.Code=gGetObjValue("DescriptionCode");
	    Description.Desc=gGetObjValue("Description");
	    ResumeText=gGetObjValue("ResumeText");
	    Opinion.Code=gGetObjValue("OpinionCode");
	    Opinion.Desc=gGetObjValue("Opinion");
	    ReportLocation.Desc=gGetObjValue("ReportLocation");
	    ReportLocation.Rowid=gGetObjValue("ctloc");
	    ReportPlace.Desc=gGetObjValue("ReportPlace");
	    ReportPlace.Code=gGetObjValue("ReportPlaceCode");
	    
	    RepUser.Rowid=gGetObjValue("ReportUserRowid");
	    RepUser.Desc=gGetObjValue("ReportUser");
	    ReportDate=gGetObjValue("ReportDate");
	    ReportTime=gGetObjValue("ReportTime");
	    CheckUser.Desc=gGetObjValue("CheckUser");
	    CheckUser.Rowid=gGetObjValue("CheckUserRowid");
	    CheckDate=gFormatDateA(gGetObjValue("CheckDate"));
	    CheckTime=gGetObjValue("CheckTime");
	}
	return objTMPPVMReport;
}

function BuildPVMReportString(objTMPEpidemicReport){
	with(objTMPEpidemicReport){
		var PVMReportString=
		Rowid+"^"+
		ReportNo+"^"+
		ReportType.Code+"^"+
		Status.Code+"^"+		
		gGetObjValue("INCItmID")+"^"+
		INCItmBat.Rowid+"^"+
		ReportQty+"^"+
		InStockQty+"^"+
		StockQty+"^"+
		//Description.Code+"^"+
		GetTableString()+"^"+
		ResumeText+"^"+
		Opinion.Code+"^"+
		ReportLocation.Rowid+"^"+
		ReportPlace.Code+"^"+
		RepUser.Rowid+"^"+
		ReportDate+"^"+
		ReportTime+"^"+
		CheckUser.Rowid+"^"+
		CheckDate+"^"+
		CheckTime+"^"+
		TEXT1+"^"+                     //TEXT1
		TEXT2                          //TEXT2
		}
	return PVMReportString;
	}

function BuildPVMReportDtlString(objTMPEpidemicReport){
	with(objTMPEpidemicReport){
		var BuildPVMReportDtlString=
		Rowid+"^"+                  //Parref
    ""+"^"+                     //ChildSub
    Opinion.Code+"^"+           //Opinion    
    objLogUser.Rowid+"^"+       //User
    ""+"^"+ 
    ""+"^"+      
		""                          //Resume
		}
	return BuildPVMReportDtlString;
	}
