
function clsDictionary(id){	
    this.Rowid=id;   
	this.Code="";
	this.Desc="";
	}

function clsStudent(sName){	
	this.Name=sName;
	this.Birthday="";
	this.body=new clsBody(180);
	}

function clsBody(Asize){
	this.size=Asize;
	this.weight="";
	}
function clsWebConfig(Asize){
	this.CurrentNS="";
	this.MEDDATA="";
	this.LABDATA="";
	this.Server="";
	this.Path="";
	this.LayOutManager="";
	}

function clsLogUser(Rowid){
	this.Rowid=Rowid;
	this.Code="";
	this.Name="";
	this.CtLoc=new clsDictionary("");
	this.CDep=new clsDictionary("");
	this.SGroup=new clsDictionary("");	
	}
function clsPatient(papmi){
	this.Rowid=papmi;                   ///Papmi
	this.Occupation="";                   ///
	this.Payment="";                   ///
	this.RelativeAddress="";                   ///
	this.Relation="";                   ///
	this.NativePlace="";                   ///
	this.Education="";                   ///
	this.Marriage="";                   ///
	this.Nation="";                   ///
	this.Nationality="";                   ///
	this.PatientName="";                   ///
	this.Company="";                   ///
	this.RelativeName="";                   ///
	this.Telephone="";                   ///
	this.NowAddress="";                   ///
	this.Age="";                   ///
	this.Birthday="";                   ///
	this.Identity="";                   ///
	this.Sex="";                   ///
	this.MedRecNo="";                   ///
	this.PatientNo="";                   ///
	}


function clsEpidemicReport(Rowid){
	this.Rowid=Rowid;                            ///
	this.PatientRowID="";                        ///
	this.Area=new clsDictionary("");             ///
	this.Occupation=new clsDictionary("");       ///
	this.FamName="";                             ///
	this.ICD=new clsEpdICD("");                  ///
	this.Intimate=new clsDictionary("");         ///
	this.DiagnoseType="";                        ///
	this.SickDate="";                            ///
	this.DiagDegree=new clsDictionary("");       ///
	this.DiagnoseDate="";                        ///
	this.SickKind=new clsDictionary("");         ///
	this.DeathDate="";                           ///
	this.ReportLocation=new clsDictionary("");   ///
	this.ReportPlace=new clsDictionary("");      ///
	this.Status=new clsDictionary("");           ///
	this.ReportUser=new clsDictionary("");       ///
	this.ReportDate="";                          ///
	this.ReportTime="";                          ///
	this.CheckUser1=new clsDictionary("");       ///
	this.CheckDate1="";                          ///
	this.CheckTime1="";                          ///
	this.ResumeText="";                          ///
	this.DeleteReason="";                        ///
	this.CorrectedReportRowID="";                ///
	this.AppendixItems=new clsDictionary("");    ///
	this.Telphone="";                            ///
	this.Address="";                             ///
	this.Company="";                             ///
	//add by zf 2008-11-08
	this.IDAddress="";                           ///
	this.TEXT1="";                               ///
	this.TEXT2="";                               ///
	}

function clsEpidemicReportSub(ParRef){
	this.ParRef=ParRef;
	this.Rowid="";
	this.ChildSub="";
	this.DataType=new clsDictionary("");         ///
	this.Value="";	
	}

function clsEpdICD(Rowid){
	this.Rowid=Rowid;
	this.Code="";
	this.Desc="";
	this.Type="";
	this.Rank="";
	this.Appendix="";
	this.Multi="";
	this.Dependence="";
	this.TimeLimit="";
	}
///Add by cjb 2009-06-11 ///药物警戒报告 错误
function clsPVMReport(Rowid){
	this.Rowid=Rowid;                            /// 
	this.ReportNo="";   
	this.ReportType=new clsDictionary("");                          ///
	this.Status=new clsDictionary("");   
	this.INCItmBat=new clsINCItmBat("");         ///药物批号
	this.ReportQty="";                              ///
	this.InStockQty="";                             ///
	this.StockQty="";  
	this.Description=new clsDictionary(""); 
	this.ResumeText=""; 
	this.Opinion=new clsDictionary("");
	this.ReportLocation=new clsDictionary("");   ///报告部门
	this.ReportPlace=new clsDictionary("");      ///报告位置                    
	this.RepUser=new clsDictionary("");         ///
	this.ReportDate="";                          ///
	this.ReportTime="";
	this.CheckUser=new clsDictionary("");       ///
	this.CheckDate="";                          ///
	this.CheckTime="";                          ///
	this.TEXT1="";
	this.TEXT2="";
	}
///药物批次	
function clsINCItmBat(Rowid){
	this.Rowid=Rowid;                            /// 
	this.INCItmName="";   
	this.INCItmBatNo="";                          ///
	this.ProComp="";                              ///
	this.ExpDate="";                             ///
	}