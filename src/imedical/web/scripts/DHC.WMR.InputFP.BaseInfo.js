//2008-1-18 By LiYang
var strNew = "";
var strDel =  "";
var strNoticeTitle =  "";
var strSummaryGridTitle =  "";
var strName =  "";
var strSex =  "";
var strBirthday =  "";
var strAge =  "";
var strWedlock =  "";
var strOccupation =  "";
var strCity = "";
var strProvince = "";
var strNation =  "";
var strNationality =  "";
var strPersonalID =  "";
var strCompany =  "";
var strCompanyTel =  "";
var strAddress =  "";
var strAddressTel =  "";
var strRelationName =  "";
var srtRelation =  "";
var strRelationAddress =  "";
var strRelationTel =  "";

var strBaseFromTitle =  "";
var strPaneBaseInfo =  "";
var strPaneAdmitInfo =  "";
var strAdmitDate =  "";
var strDischargeDate =  "";
var strAdmitDep =  "";
var strDischargeDep =  "";

var strMrNo = "";
var strRegNo = "";

var strNextPage = "";


var txtMrNo = null;
var txtRegNo = null;
var txtName = null;
var txtSex = null;
var txtBirthday = null;
var txtAge = null;
var txtWedlock = null;
var txtOccupation = null;
var txtCity = null;
var txtProvince = null;
var txtNation = null;
var txtNationality = null;
var txtPersonalID = null;
var txtCompany = null;
var txtCompanyTel = null;
var txtAddress = null;
var txtAddressTel = null;
var txtRelationName = null;
var txtRelation = null;
var txtRelationAddress = null;
var txtRelationTel = null;

var txtAdmitDate = null;
var txtAdmitDep = null;
var txtDischargeDate = null;
var txtDischargeDep = null;

var btnNextPage = null;//new Ext.Button({text:strNextPage, handler:btnNextPageOnClick});

var frmBaseInfo = null;
var objCurrAdm = new Object();  //Store Current Admit information
var objCurrBase = null; //Store Current Patient base information


function InitBaseInfo()
{
		strNextPage = t["strNextPage"];
		strNew = t["strNew"];
		strDel = t["strDel"];
		strNoticeTitle = t["strNoticeTitle"];
		strSummaryGridTitle = t["strSummaryGridTitle"];
		strName = t["strName"];
		strSex = t["strSex"];
		strBirthday = t["strBirthday"];
		strAge = t["strAge"];
		strWedlock = t["strWedlock"];
		strOccupation = t["strOccupation"];
		strCity = t["strCity"];
		strProvince = t["strProvince"];
		strNation = t["strNation"];
		strNationality = t["strNationality"];
		strPersonalID = t["strPersonalID"];
		strCompany = t["strCompany"];
		strCompanyTel = t["strCompanyTel"];
		strAddress = t["strAddress"];
		strAddressTel = t["strAddressTel"];
		strRelationName = t["strRelationName"];
		srtRelation = t["srtRelation"];
		strRelationAddress = t["strRelationAddress"];
		strRelationTel = t["strRelationTel"];
		
		strBaseFromTitle = t["strBaseFromTitle"];
		strPaneBaseInfo = t["strPaneBaseInfo"];
		strPaneAdmitInfo = t["strPaneAdmitInfo"];
		strAdmitDate = t["strAdmitDate"];
		strDischargeDate = t["strDischargeDate"];
		strAdmitDep = t["strAdmitDep"];
		strDischargeDep = t["strDischargeDep"];
		
		strMrNo = t["strMrNo"];
		strRegNo = t["strRegNo"];
		
		strNextPage = t["strNextPage"];
			txtMrNo = new Ext.form.TextField({fieldLabel: strMrNo,width:200});
			txtRegNo = new Ext.form.TextField({fieldLabel: strRegNo,width:200});
			txtName = new Ext.form.TextField({fieldLabel: strName,width:200});
			txtSex = new Ext.form.TextField({fieldLabel: strSex,width:200});
			txtBirthday = new Ext.form.TextField({fieldLabel: strBirthday,width:200});
			txtAge = new Ext.form.TextField({fieldLabel: strAge,width:200});
			txtWedlock = new Ext.form.TextField({fieldLabel: strWedlock,width:200});
			txtOccupation = new Ext.form.TextField({fieldLabel: strOccupation,width:200});
			txtCity = new Ext.form.TextField({fieldLabel: strCity,width:200});
			txtProvince = new Ext.form.TextField({fieldLabel: strProvince,width:200});
			txtNation = new Ext.form.TextField({fieldLabel: strNation,width:200});
			txtNationality = new Ext.form.TextField({fieldLabel: strNationality,width:200});
			txtPersonalID = new Ext.form.TextField({fieldLabel: strPersonalID,width:200});
			txtCompany = new Ext.form.TextField({fieldLabel: strCompany,width:200});
			txtCompanyTel = new Ext.form.TextField({fieldLabel: strCompanyTel,width:200});
			txtAddress = new Ext.form.TextField({fieldLabel: strAddress,width:200});
			txtAddressTel = new Ext.form.TextField({fieldLabel: strAddressTel,width:200});
			txtRelationName = new Ext.form.TextField({fieldLabel: strRelationName,width:200});
			txtRelation = new Ext.form.TextField({fieldLabel: srtRelation,width:200});
			txtRelationAddress = new Ext.form.TextField({fieldLabel: strRelationAddress,width:200});
			txtRelationTel = new Ext.form.TextField({fieldLabel: strRelationTel,width:200});
				
			txtAdmitDate = new Ext.form.TextField({fieldLabel: strAdmitDate,width:200});
			txtAdmitDep = new Ext.form.TextField({fieldLabel: strAdmitDep,width:200});
			txtDischargeDate = new Ext.form.TextField({fieldLabel: strDischargeDate,width:200});
			txtDischargeDep = new Ext.form.TextField({fieldLabel: strDischargeDep,width:200});
			btnNextPage = new Ext.Button({text:strNextPage, handler:btnNextPageOnClick});
			
        var obj = null;
    
         Ext.QuickTips.init();   

        Ext.form.Field.prototype.msgTarget = 'side';
        var objSetting = {
            labelAlign: 'left',
            frame:true,
            //title: strSummaryGridTitle,
            bodyStyle:'padding:5px 5px 0',
            //width: 800,
            height:1000,
            renderTo:"BaseInfoGrid",
           // title:strSummaryGridTitle,
            items: [
                    {
                        xtype:'fieldset',
                        title: strPaneBaseInfo,
                        //autoHeight:true,
                        defaults: {width: 800},
                        //defaultType: 'textfield',
                        items:[
                        		{
                        			layout:'column',
                        			items:[
                        				{
					                      	columnWidth:.5,
									                layout: 'form',
									                items: [txtMrNo,txtName,txtBirthday,txtWedlock,txtCity,txtNation,txtPersonalID,txtCompanyTel,txtAddressTel,txtRelation,txtRelationTel]
					                      },
					                      {
					                      	columnWidth:.5,
									                layout: 'form',
									                items: [txtRegNo,txtSex,txtAge,txtOccupation,txtProvince,txtNationality,txtCompany,txtAddress,txtRelationName,txtRelationAddress]
					                      }
                        			]	
                        		}
                        ]
	                     }, {
                        xtype:'fieldset',
                        title: strPaneAdmitInfo,
                        //autoHeight:true,
                        defaults: {width: 800},
                        //defaultType: 'textfield',
                        items:[
                        		{
                        			layout:'column',
                        			items:[
                        				{
					                      	columnWidth:.5,
									                layout: 'form',
									                items: [txtAdmitDate,txtDischargeDate]
					                      },
					                      {
					                      	columnWidth:.5,
									                layout: 'form',
									                items: [txtAdmitDep,txtDischargeDep]
					                      }
                        			]	
                        		}
                        ]
	                     }
                     /*{
                          xtype:'fieldset',
                        title: strPaneAdmitInfo,
                        //autoHeight:true,
                        defaults: {width: 200},
                        defaultType: 'textfield',
                        //collapsed: true,
                        items :[
                        		{
                        			layout:'column',
                        			items:[
                        				{
					                      	columnWidth:.5,
									                layout: 'form',
									                items: [txtAdmitDate,txtDischargeDate]
					                      },
					                      {
					                      	columnWidth:.5,
									                layout: 'form',
									                items: [txtAdmitDep,txtDischargeDep]
					                      }
                        			]	
                        		}
                        ]                    
                     }*/
                     
                     ],
             buttons:[btnNextPage]
        };

        frmBaseInfo = new Ext.FormPanel(objSetting);
   /* frmBaseInfo = new Ext.FormPanel({
        labelAlign: 'top',
        frame:true,
        title: 'Multi Column, Nested Layouts and Anchoring',
        bodyStyle:'padding:5px 5px 0',
        width: 600,
        items: [{
            layout:'column',
            items:[{
                columnWidth:.5,
                layout: 'form',
                items: [{
                    xtype:'textfield',
                    fieldLabel: 'First Name',
                    name: 'first',
                    anchor:'95%'
                }, {
                    xtype:'textfield',
                    fieldLabel: 'Company',
                    name: 'company',
                    anchor:'95%'
                }]
            },{
                columnWidth:.5,
                layout: 'form',
                items: [{
                    xtype:'textfield',
                    fieldLabel: 'Last Name',
                    name: 'last',
                    anchor:'95%'
                },{
                    xtype:'textfield',
                    fieldLabel: 'Email',
                    name: 'email',
                    vtype:'email',
                    anchor:'95%'
                }]
            }]
        },{
            xtype:'htmleditor',
            id:'bio',
            fieldLabel:'Biography',
            height:200,
            anchor:'98%'
        }],

        buttons: [{
            text: 'Save'
        },{
            text: 'Cancel'
        }]
    });*/
}

function btnNextPageOnClick()
{
    objTabs.activate(objExtraTab);
    if(arryExtraControl.length > 0)
  	{
  		arryExtraControl[0].focus();
  	}
  	else
  	{
  		objTabs.activate(objDisTab);
  		cboDiseaseICD.focus();
  	}
}

function DisplayPatientBaseInformation(objInfo, objMain, objPatient)
{
	if(objInfo != null)
	{
		LeadingFactor =document.getElementById("LeadingFactor").value;//主导因素
		if(LeadingFactor=="V") {
			//卷主导
			var VolString=tkMakeServerCall("web.DHCWMRVolumeCtl","GetVolume",strVolRowID);
			var VolNo=VolString.split("^")[10];
			txtMrNo.setValue(VolNo);
		}else{
			txtMrNo.setValue(objMain.MRNO);
	  }
		txtRegNo.setValue(objPatient.PatientNo);
		//**************START***************
		//update by zf 20090903
    txtName.setValue(objPatient.PatientName);
    txtSex.setValue(objPatient.Sex);
    txtBirthday.setValue(objPatient.Birthday);
    txtAge.setValue(objPatient.Age);
    txtWedlock.setValue(objPatient.Wedlock);
    txtOccupation.setValue(objPatient.Occupation);
    txtCity.setValue(objPatient.City);
    txtProvince.setValue(objPatient.County);
    txtNation.setValue(objPatient.Nation);
    txtNationality.setValue(objPatient.Nationality);
    txtPersonalID.setValue(objPatient.IdentityCode);
    txtCompany.setValue(objPatient.Company);
    txtCompanyTel.setValue(objPatient.CompanyTel);
    txtAddress.setValue(objPatient.HomeAddress);
    txtAddressTel.setValue(objPatient.HomeTel); 
    txtRelationName.setValue(objPatient.RelativeName); 
    txtRelation.setValue(objPatient.RelationDesc); 
    txtRelationAddress.setValue(objPatient.RelativeAddress); 
    txtRelationTel.setValue(objPatient.RelativeTel);  
    
    //txtName.setValue(objInfo.PatientName);
    //txtSex.setValue(objInfo.Sex);
    //txtBirthday.setValue(objInfo.Birthday);
    //txtAge.setValue(objInfo.Age);
    //txtWedlock.setValue(objInfo.Wedlock);
    //txtOccupation.setValue(objInfo.Occupation);
    //txtCity.setValue(objInfo.City);
    //txtProvince.setValue(objInfo.County);
    //txtNation.setValue(objInfo.Nation);
    //txtNationality.setValue(objInfo.Nationality);
    //txtPersonalID.setValue(objInfo.IdentityCode);
    //txtCompany.setValue(objInfo.Company);
    //txtCompanyTel.setValue(objInfo.CompanyTel);
    //txtAddress.setValue(objInfo.HomeAddress);
    //txtAddressTel.setValue(objInfo.HomeTel); 
    //txtRelationName.setValue(objInfo.RelativeName); 
    //txtRelation.setValue(objInfo.RelationDesc); 
    //txtRelationAddress.setValue(objInfo.RelativeAddress); 
    //txtRelationTel.setValue(objInfo.RelativeTel);  
    //****************END****************
  }
	else
	{
		txtMrNo.setValue(objMain.MRNO);
		txtRegNo.setValue(objPatient.PatientNo);
    txtName.setValue(objPatient.PatientName);
    txtSex.setValue(objPatient.Sex);
    txtBirthday.setValue(objPatient.Birthday);
    txtAge.setValue(objPatient.Age);
    txtWedlock.setValue(objPatient.Wedlock);
    txtOccupation.setValue(objPatient.Occupation);
    txtCity.setValue(objPatient.City);
    txtProvince.setValue(objPatient.County);
    txtNation.setValue(objPatient.Nation);
    txtNationality.setValue(objPatient.Nationality);
    txtPersonalID.setValue(objPatient.IdentityCode);
    txtCompany.setValue(objPatient.Company);
    txtCompanyTel.setValue(objPatient.CompanyTel);
    txtAddress.setValue(objPatient.HomeAddress);
    txtAddressTel.setValue(objPatient.HomeTel); 
    txtRelationName.setValue(objPatient.RelativeName); 
    txtRelation.setValue(objPatient.RelationDesc); 
    txtRelationAddress.setValue(objPatient.RelativeAddress); 
    txtRelationTel.setValue(objPatient.RelativeTel);  		
	}
}

function ClearPatientBaseInformation()
{
		txtMrNo.setValue("");
		txtRegNo.setValue("");
    txtName.setValue("");
    txtSex.setValue("");
    txtBirthday.setValue("");
    txtAge.setValue("");
    txtWedlock.setValue("");
    txtOccupation.setValue("");
    txtCity.setValue("");
    txtProvince.setValue("");
    txtNation.setValue("");
    txtNationality.setValue("");
    txtPersonalID.setValue("");
    txtCompany.setValue("");
    txtCompanyTel.setValue("");
    txtAddress.setValue("");
    txtAddressTel.setValue(""); 
    txtRelationName.setValue(""); 
    txtRelation.setValue(""); 
    txtRelationAddress.setValue(""); 
    txtRelationTel.setValue("");  
}

function DisplayPatientAdmitInformation(objAdm)
{
    txtAdmitDate.setValue(objAdm.AdmDate);
    txtAdmitDep.setValue(GetDesc(objAdm.LocDesc, "/"));
    txtDischargeDate.setValue(objAdm.DischgDate);
    txtDischargeDep.setValue(GetDesc(objAdm.LocDesc, "/"));   
    
    objCurrAdm.AdmitDate = objAdm.AdmDate;
    objCurrAdm.AdmitDep = GetDesc(objAdm.LocDesc, "/");
    objCurrAdm.DisDate = objAdm.DischgDate;
    objCurrAdm.DisDep = GetDesc(objAdm.LocDesc, "/");
}

function DisplayPatientHistoryAdmitInformation(objAdm)
{
    txtAdmitDate.setValue(objAdm.AdmitDate);
    txtAdmitDep.setValue(objAdm.AdmitDep);
    txtDischargeDate.setValue(objAdm.DischargeDate);
    txtDischargeDep.setValue(objAdm.DischargeDep);   
    
    objCurrAdm.AdmitDate = objAdm.AdmitDate;
    objCurrAdm.AdmitDep = objAdm.AdmitDep;
    objCurrAdm.DisDate = objAdm.DischargeDate;
    objCurrAdm.DisDep = objAdm.DischargeDep;    
}