
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
	//add by zf 2008-11-17
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
