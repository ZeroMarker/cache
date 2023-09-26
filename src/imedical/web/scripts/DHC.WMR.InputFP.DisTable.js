var strInputDisease = "";//t["strName"];
var strDiseaseICD="";
var strDiseaseName="";
var strDiseaseResult="";
var strDiseaseGridTitle ="";
var objGridDisease = null;
var objGridHisDisease = null;
var cboDiseaseICD = null;
var cboDiseaseResult = null;
var cboDiseaseType = null;
var arryDisTblFields = null;
var dicDisTblFields = new ActiveXObject("Scripting.Dictionary");
var frmDisease = null;
var objDiseaseType = null;

function InitDiseaseGrid(){
	objDiseaseType=GetDHCWMRDictionaryByTypeCode("MethodGetDHCWMRDictionaryByTypeCode", "ICDType", "D");// {RowID:47,Code:"D",Description:"疾病"};//DHCWMRDictionary of item type 'disease'
	strInputDisease = t["strName"];
	strDiseaseICD=t["strDiseaseICD"];
	strDiseaseName=t["strDiseaseName"];
	strDiseaseResult=t["strDiseaseResult"];
	strDiseaseGridTitle =t["strDiseaseGridTitle"];
	strDiseaseResume =t["strDiseaseResume"];

	Ext.QuickTips.init();
	Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	var myData = [];
	cboDiseaseICD = CreateICDDicQueryComboBox("D", strDiseaseICD);
	cboDiseaseResult = new Ext.form.ComboBox({
	    fieldLabel: strDiseaseResult,
	    editable: true,
	    mode: 'local',
	    triggerAction: 'all',
	    store: CreateDicStore(
			GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "DiseaseResult", "Y"),
			"RowID",
			"Description"
		),
	    mode: 'local',
	    displayField: "Description",
	    valueField: "RowID"
	}); 
	cboDiseaseType = new Ext.form.ComboBox({
    		fieldLabel:t["DiseaseType"],
    		editable:false,
    		mode: 'local',
    		triggerAction: 'all',
		store:CreateDicStore(
			GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "FPICDType", "Y"),
			"RowID",
			"Description"
		),
    		mode:'local',
    		displayField:"Description",
    		valueField:"RowID"
    	});
    					
	SelectFirstComboBoxItem(cboDiseaseType);
	SelectFirstComboBoxItem(cboDiseaseResult); //Add By LiYang 2009-05-15
	
	//cboDiseaseICD.setWidth(30);
	//cboDiseaseResult.setWidth(30);
	//cboDiseaseType.setWidth(80);
    
	//Add by wuqk 2008-05-28
	//txtDiseaseResume = new Ext.form.TextField({fieldLabel:strDiseaseResume});
	//update by zf 2008-07-02
	//txtDiseaseResume = CreateDicQueryComboBox("QuestionDiagnose", strDiseaseResume);
	txtDiseaseResume = new Ext.form.ComboBox({
    		fieldLabel:strDiseaseResume,
    		editable:true,
    		mode: 'local',
    		triggerAction: 'all',
		store:CreateDicStore(
			GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "QuestionDiagnose", "Y"),
			"RowID",
			"Description"
		),
    		mode:'local',
    		displayField:"Description",
    		valueField:"RowID"
    	});
  SelectFirstComboBoxItem(txtDiseaseResume);
	arryDisTblFields = [cboDiseaseICD, cboDiseaseResult, cboDiseaseType,txtDiseaseResume]; 
	
	cboDiseaseICD.setWidth(210);
	cboDiseaseResult.setWidth(150);
	cboDiseaseType.setWidth(220);
	txtDiseaseResume.setWidth(150);

	// create the data store
	var store = new Ext.data.SimpleStore({
		fields: [
		   {name: 'RowID'},
		   {name: 'ICDCode'},
		   {name: 'ICDDescription'},
		   {name: 'DiseaseResult'},
		   {name: 'Position'},
		   {name: 'DiagnoseType'},
		   {name: 'RelatedDiagnoseTypeDic'},
		   {name: 'RelatedICDDic'},
		   {name: 'RelatedDisResultDic'},
		   {name: 'Resume'},
		   {name: 'RelatedResume'},     //update by zf 2008-07-02
		   //{name: 'lastChange', type: 'date', dateFormat: 'n/j h:ia'}
		],
		sortInfo:{field:"Position", direction:"ASC"}
	});
	store.loadData(myData);
	objDiseaseRecord=store;
	
	// create the Grid
	objGridHisDisease = new Ext.grid.GridPanel({
	        store: new Ext.data.SimpleStore({
			fields: [
				{name: 'RowID'},
				{name: 'ICDCode'},
				{name: 'ICDDescription'},
				{name: 'DiagnoseType'},
				{name: 'DoctorCode'},
				{name: 'Doctor'},
				{name: 'DiagnoseDate'},
				{name: 'DiagnoseTime'},
				{name: 'objAdmitDiagnose'},
				{name: 'objRepDiagnose'},
				{name: 'checked'},
				{name: 'pChange'},
				{name: 'Resume'},
				{name: 'DischargeState'}    //add by zf 2008-06-10
			]
		}),
		columns: [
			new Ext.grid.RowNumberer(),
			{id:'RowID', header: strDiseaseICD, width: 100, sortable: false, dataIndex: 'ICDCode'},
			{header: strDiseaseName, width: 300, sortable: false, dataIndex: 'ICDDescription'},
			{header: strDiseaseResult, width: 100, sortable: false,  dataIndex: 'DischargeState'},
			{header: t["DiagnoseType"], width: 100, sortable: false,  dataIndex: 'DiagnoseType'},
			//{header: t["DoctorCode"], width: 75, sortable: false,  dataIndex: 'DoctorCode'},
			//{header: t["DoctorName"], width: 75, sortable: false,  dataIndex: 'Doctor'},
			//{header: t["DiagnoseDate"], width: 75, sortable: false,  dataIndex: 'DiagnoseDate'},
			//{header: t["DiagnoseTime"], width: 75, sortable: false,  dataIndex: 'DiagnoseTime'},
			{header: strDiseaseResume, width: 200, sortable: false,  dataIndex: 'Resume'}

		],
		stripeRows: true,
		//autoExpandColumn: 'ICDCode',
		height:200,
		width:980
	}); 
	
	var grid = new Ext.grid.GridPanel({
		store: store,
		columns: [
			new Ext.grid.RowNumberer(),
			{id:'RowID', header: strDiseaseICD, width: 100, sortable: false, dataIndex: 'ICDCode'},
			{header: strDiseaseName, width: 300, sortable: false, dataIndex: 'ICDDescription'},
			{header: strDiseaseResult, width: 100, sortable: false,  dataIndex: 'DiseaseResult'},
			{header: t["DiseaseType"], width: 100, sortable: false,  dataIndex: 'DiagnoseType'},
			{header: strDiseaseResume, width: 200, sortable: false,  dataIndex: 'Resume'}
		],
		stripeRows: true,
		//autoExpandColumn: 'ICDCode',
		height:200,
		width:980,
		tbar: [
		{
			text:t["AddFromHis"],
			handler:function()
			{
				var objRec = GetGridSelectedData(objGridHisDisease);
				if(objRec == null) return;
				var objDisStore = objGridDisease.getStore();
				
				var objICD = null;
				var objDisResult = null;
				var objDiagnoseType = null;
				var objResume = null;
				var objData = null;
				var objDic = null;
				
				var arryICDType = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "FPICDType", "Y");
				var arryDiseaseResult = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "DiseaseResult", "Y");
				var arryResume = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "QuestionDiagnose", "Y");
				
				var objICD = GetDHCWMRDiseaseICDDxByID("MethodGetDHCWMRDiseaseICDDxByID", objRec.get("RowID"));
				if (objICD==null)
				{
					objICD = new DHCWMRICDDx();
					//objICD.RowID = objRec.get("RowID");
					//objICD.ICD = objRec.get("ICDCode");
					objICD.Name = objRec.get("ICDDescription");
				}
		
				objDiagnoseType=null;
				for (var Ind=0;Ind<arryICDType.length;Ind++)
				{
					objDic=arryICDType[Ind];
					if (objRec.get("DiagnoseType")==objDic.Description)
					{
						objDiagnoseType=objDic;
						break;
					}
				}
				if (objDiagnoseType==null){objDiagnoseType = new DHCWMRDictionary();}
				
				objDisResult=null;
				for (var Ind=0;Ind<arryDiseaseResult.length;Ind++)
				{
					objDic=arryDiseaseResult[Ind];
					if (objRec.get("DischargeState")==objDic.Description)
					{
						objDisResult=objDic;
						break;
					}
				}
				if (objDisResult==null){objDisResult = new DHCWMRDictionary();}
				
				objResume=null;
				for (var Ind=0;Ind<arryResume.length;Ind++)
				{
					objDic=arryResume[Ind];
					if (objDic.Code=="1")
					{
						objResume=objDic;
						break;
					}
				}
				if (objResume==null){objResume = new DHCWMRDictionary();}
		
				objData = new Ext.data.Record({
					RowID: "",
					ICDCode: objICD.ICD,
					ICDDescription: objICD.Name,
					DiseaseResult: objDisResult.Description,
					RelatedICDDic: objICD,
					RelatedDisResultDic: objDisResult,
					Position: objDisStore.getCount(),
					DiagnoseType: objDiagnoseType.Description,
					RelatedDiagnoseType: objDiagnoseType,
					Resume: objResume.Description,
					RelatedResume: objResume
				});
				objDisStore.add(objData);
				/*
				var objStore = cboDiseaseType.initialConfig.store;
				var objTypeDic = null;
				var objSec = null;
				if(data.getCount() > 0){
					if(objStore.getCount() > 1){
						objSec = objStore.getAt(1);
						cboDiseaseType.setValue(objSec.get("RowID"));
					}
				}*/
			}
		},
		{
			text: strDel,
			handler : RemoveDisease
		},
		{
			text:t["Up"],  //Add By LiYang 2009-05-16  User Can change record position
			handler:function()
			{
				var objRec = GetGridSelectedData(objGridDisease);
				var objStore = objGridDisease.getStore();
				if (objRec == null)
					return;
				var intPos = objStore.indexOf(objRec);
				if (intPos > 0)
				{
					objStore.remove(objRec);
					objStore.insert(intPos - 1, [objRec]);
					objGridDisease.getSelectionModel().selectRow(intPos -1);   //add by liulan 2013-10-23
				}
			}
		},
		{
			text:t["Down"],  //Add By LiYang 2009-05-16  User Can change record position
			handler:function()
			{
				var objRec = GetGridSelectedData(objGridDisease);
				var objStore = objGridDisease.getStore();
				if (objRec == null)
					return;
				var intPos = objStore.indexOf(objRec);
				if (intPos < objStore.getCount())
				{
					objStore.remove(objRec);
					objStore.insert(intPos + 1, [objRec]);
					objGridDisease.getSelectionModel().selectRow(intPos +1);  //add by liulan 2013-10-23
				}
			}			
		},
		{
		    text: t["SaveToGrid"],  //Add By LiYang 2009-07-24  User Can change record
		    handler: function() {
		        var objRec = GetGridSelectedData(objGridDisease);
		        var objStore = objGridDisease.getStore();
		        if (objRec == null)
		            return;
			ModifyDisease(objRec);
		    }
		}]
	}); 
        Ext.form.Field.prototype.msgTarget = 'side';
        
        // new Ext.Panel
	var pnInput =({
		title:strDiseaseGridTitle,
		xtype:'fieldset',
		frame:true,
		//autoHeight:true,
		defaults: {width: 980},
		//defaultType: 'textfield',
		items:[{
			layout:'column',
			items:[
				{
					columnWidth:.5,
					layout: 'form',
					items: [cboDiseaseICD,cboDiseaseType]
				},
				{
					columnWidth:.5,
					layout: 'form',
					items: [cboDiseaseResult,txtDiseaseResume]
				}
			]
		}]
	});
	var objSetting = {
		labelAlign: 'left',
		frame:true,
		bodyStyle:'padding:5px 5px 0',
		width: 1000,
		renderTo:"DiseaseGrid",
		items: [
			objGridHisDisease,
			grid,
			pnInput
		]
	};
	frmDisease = new Ext.FormPanel(objSetting);
	objGridDisease = grid;
	initDiseaseTableEvent(); 
	//Add By LiYang 2009-07-24 when user click one grid item, display it's info into input panel
	grid.on("click",
	    function() {
		        var objRec = GetGridSelectedData(objGridDisease);
		        if (objRec == null)
		            return;
		        DisplayDisRec(objRec);
		    }
		);
}

function AddDisease()
{
	var arryData = new Array();
	var objItem = new Array();
	var objICD = GetDHCWMRDiseaseICDDxByID("MethodGetDHCWMRDiseaseICDDxByID", cboDiseaseICD.getValue());
	//var objDisResult = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboDiseaseResult.getValue());
	//var objDiagnoseType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboDiseaseType.getValue());
	//update by zf 2008-07-02
	//var objResume = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", txtDiseaseResume.getValue());
	//update by LiYang 2008-07-28 
	//In friendship hospital, "ResumeText" Filed is empty so it will lead a runtime error about null pointer.
	//if objResume point to null, i will create a new Dictionary Object.
	//if(objResume == null)
	//		objResume = new DHCWMRDictionary();
	var objResume = new DHCWMRDictionary();
	if ((txtDiseaseResume.getRawValue()!=="")&&(txtDiseaseResume.getValue()!==""))
	{
		objResume = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", txtDiseaseResume.getValue());
	}
	var objDisResult = new DHCWMRDictionary();
	if ((cboDiseaseResult.getRawValue()!=="")&&(cboDiseaseResult.getValue()!==""))
	{
		objDisResult = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboDiseaseResult.getValue());
	}
	var objDiagnoseType = new DHCWMRDictionary();
	if ((cboDiseaseType.getRawValue()!=="")&&(cboDiseaseType.getValue()!==""))
	{
		objDiagnoseType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboDiseaseType.getValue());
	}
			
	var data = objGridDisease.getStore();
	var objData =new Ext.data.Record({
		RowID:"",
		ICDCode:objICD.ICD,
		ICDDescription:objICD.Name,
		DiseaseResult:objDisResult.Description,
		RelatedICDDic:objICD,
		RelatedDisResultDic:objDisResult,
		Position:data.getCount(),
		DiagnoseType:objDiagnoseType.Description,
		RelatedDiagnoseType:objDiagnoseType,
		//update by zf 2008-07-02
		//Resume:txtDiseaseResume.getValue(),
		Resume:objResume.Description,
		RelatedResume:objResume
	});
	
	data.add([objData]);
	//data.removeAll();
	// a();
	var objStore = cboDiseaseType.initialConfig.store;
	var objTypeDic = null;
	var objSec = null;	
	if(data.getCount() > 0){
		if(objStore.getCount() > 1){
			objSec = objStore.getAt(1);
			cboDiseaseType.setValue(objSec.get("RowID"));
		}
	}
}


//Modify Disease record
function ModifyDisease(objRec)
{
	if ((cboDiseaseICD.getValue()=="")||(cboDiseaseType.getValue()=="")||(cboDiseaseICD.getRawValue()=="")||(cboDiseaseType.getRawValue()==""))
	{
		alert(t["ErrDiagContent"]);
		return;
	}
	var arryData = new Array();
	var objItem = new Array();
	var objICD = GetDHCWMRDiseaseICDDxByID("MethodGetDHCWMRDiseaseICDDxByID", cboDiseaseICD.getValue());
	if (objICD==null) return;
	var objResume = new DHCWMRDictionary();
	if ((txtDiseaseResume.getRawValue()!=="")&&(txtDiseaseResume.getValue()!==""))
	{
		objResume = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", txtDiseaseResume.getValue());
	}
	var objDisResult = new DHCWMRDictionary();
	if ((cboDiseaseResult.getRawValue()!=="")&&(cboDiseaseResult.getValue()!==""))
	{
		objDisResult = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboDiseaseResult.getValue());
	}
	var objDiagnoseType = new DHCWMRDictionary();
	if ((cboDiseaseType.getRawValue()!=="")&&(cboDiseaseType.getValue()!==""))
	{
		objDiagnoseType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboDiseaseType.getValue());
	}
	
	objRec.set("ICDCode",objICD.ICD);
	objRec.set("ICDDescription",objICD.Name);
	objRec.set("DiseaseResult",objDisResult.Description);
	objRec.set("RelatedICDDic",null);
	objRec.set("RelatedICDDic",objICD);
	objRec.set("RelatedDisResultDic",null);
	objRec.set("RelatedDisResultDic",objDisResult);
	objRec.set("DiagnoseType",null);
	objRec.set("DiagnoseType",objDiagnoseType.Description);
	objRec.set("RelatedDiagnoseType",null);
	objRec.set("RelatedDiagnoseType",objDiagnoseType);
	objRec.set("Resume",objResume.Description);
	objRec.set("RelatedResume",null);	
	objRec.set("RelatedResume",objResume);
	objRec.commit();
	/* 
	* add by wangcs
	* Date：2012-12-05
	* Description:主诊断编码时，自动将主诊断同步到门急诊诊断
	*/
	if (objDiagnoseType.Code=="1"){
        var gridStore=objGridDisease.getStore();
        var count=objGridDisease.getStore().getCount();
        for (var ii=0;ii<count;ii++){
		        var objRec=gridStore.getAt(ii);
            if (objRec){
		            var diagnoseTypeObj=objRec.get("RelatedDiagnoseType");
                   if (diagnoseTypeObj){
		                  var code=diagnoseTypeObj.Code;
                      if (code=="6"){   //门急诊诊断
                         objRec.set("ICDCode",objICD.ICD);
	                       objRec.set("ICDDescription",objICD.Name);
                         objRec.set("RelatedICDDic",null);
	                       objRec.set("RelatedICDDic",objICD);     
                         objRec.commit();
                      }
                   }
             }
       }
  }
  //-------------------End----------------------
}


function RemoveDisease()
{
	var objSelModel = objGridDisease.getSelectionModel();
	var data = objGridDisease.getStore();
	var strDelID = "";
	if(objSelModel.getCount() > 0){
		strDelID = objSelModel.getSelected().data.RowID;
		if(strDelID != "")
			strDelstr += strDelID + CHR_1;
		data.remove(objSelModel.getSelected());
	}
}


function initDiseaseTableEvent(){
	cboDiseaseICD.on('specialkey', DiseaseTableEventHandler, cboDiseaseICD);
	cboDiseaseResult.on('specialkey', DiseaseTableEventHandler, cboDiseaseResult);
	cboDiseaseType.on('specialkey', DiseaseTableEventHandler, txtDiseaseResume);
	txtDiseaseResume.on('specialkey', DiseaseTableEventHandler, cboDiseaseICD);
}

//handle the event of disease grid input
function DiseaseTableEventHandler(objSrc, objEvent)
{
    var keyCode = objEvent.getKey();
    var obj = null;
    for(var i = 0; i < arryDisTblFields.length; i ++)
    {
        obj = arryDisTblFields[i];
        if(obj.getId() == objSrc.getId())
            break;
    }
    switch(keyCode)
    {
        case objEvent.RETURN:
        case objEvent.ENTER:
            if(cboDiseaseICD.getValue() == "")
            {
		return;
            }
            if(i < arryDisTblFields.length-1)
            {
                arryDisTblFields[i+1].focus();
            }
            else
            {
                //try{
                    if(cboDiseaseICD.getValue() == "")
                    {
                        //objTabs.activate(objOpeTab);
                        //cboOperationICD.focus();
                    }
                    //if(cboDiseaseResult.getValue() == '')
                    //    return;
                    if(cboDiseaseType.getValue() == '')
                    		return;
                    if(ValidateInputDisease())//Validate Data
                    {
                        AddDisease(); //add disease data to the grid
                        ClearDiseaseTableInputControl();//clear user input 
                        cboDiseaseICD.focus();
                    }
                  // }catch(ex){} 
            }
            
            break;
        case objEvent.UP:
            if(i > 0)
            {
                arryDisTblFields[i-1].focus();
            }
            break;
        default:
            //window.alert(objEvent.keyCode);
            break; 
                  
    }
}

function ValidateInputDisease()
{
		if ((cboDiseaseICD.getValue()=="")||(cboDiseaseICD.getRawValue()==""))
		{
        Ext.MessageBox.show({title: strNoticeTitle, msg: strMsgInputICDCode, buttons: Ext.MessageBox.OK}); 
        cboDiseaseICD.focus();
        return false;
		}
		if ((cboDiseaseType.getValue()=="")||(cboDiseaseType.getRawValue()==""))
		{
		    Ext.MessageBox.show({title: strNoticeTitle, msg: SelectDiagnoseType, buttons: Ext.MessageBox.OK});  
        cboDiseaseType.focus();
        return false;
		}

    //if(cboDiseaseICD.getValue() == "")
    //{
    //    Ext.MessageBox.show({title: strNoticeTitle, msg: strMsgInputICDCode, buttons: Ext.MessageBox.OK}); 
    //    cboDiseaseICD.focus();
    //    return false;
    //}
    //Modified By LiYang 2009-3-2 discharge status of MainDiagnose And Other Diagnose cannot be empty
		var objDisResult = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboDiseaseResult.getValue());
		if (objDisResult==null) objDisResult = new DHCWMRDictionary();
		if ((cboDiseaseResult.getRawValue()=="")||(cboDiseaseResult.getValue()=="")) objDisResult = new DHCWMRDictionary();
		var objDiagnoseType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboDiseaseType.getValue());
    if(((objDiagnoseType.Code == '1')||(objDiagnoseType.Code == '2'))&&(objDisResult.Code ==''))
    {
        Ext.MessageBox.show({title: strNoticeTitle, msg: t["DischargeStatusError"], buttons: Ext.MessageBox.OK});  
				return false;
    }
    
    /*if(cboDiseaseResult.getValue() == "")
    {
        Ext.MessageBox.show({title: strNoticeTitle, msg: strMsgInputDiseaseResult, buttons: Ext.MessageBox.OK});  
        cboDiseaseResult.focus();
        return false;
    }
    if(cboDiseaseType.getValue() == "")
    {
        Ext.MessageBox.show({title: strNoticeTitle, msg: SelectDiagnoseType, buttons: Ext.MessageBox.OK});  
        cboDiseaseType.focus();
        return false;
    }*/
    return true;
}

function ClearDiseaseTableInputControl()
{
    cboDiseaseICD.setValue("");
    cboDiseaseResult.setValue("");
    //txtDiseaseResume.setValue("");
    SelectFirstComboBoxItem(txtDiseaseResume);// modify by liuxuefeng 2009-02-17
}    

function ClearDiseaseList()
{
	var objStore = objGridDisease.getStore();
	objStore.removeAll();
	objGridHisDisease.getStore().removeAll();
	var objStore = cboDiseaseType.initialConfig.store;
	var objSec = null;
	if(objStore.getCount() > 1)
	{
		objSec = objStore.getAt(0);
		cboDiseaseType.setValue(objSec.get("RowID"));
	}
}

function GetDiseaseList(){
	var objArry = new Array();
	var objStore = objGridDisease.getStore();
	var objData = null;
	var objDisease = null;
	for(var i = 0; i < objStore.getCount(); i ++){
		objData = objStore.getAt(i);
		objDisease = DHCWMRFPICD();
		objDisease.RowID = objData.data.RowID;
		objDisease.ICDDr = objData.data.RelatedICDDic.RowID;
		objDisease.Result = objData.data.RelatedDisResultDic.RowID
		objDisease.Pos = i + 1;
		objDisease.ItemTypeDr = objDiseaseType.RowID;
		objDisease.FPICDType = objData.data.RelatedDiagnoseType.RowID;
		//update by zf 2008-07-02
		//objDisease.ResumeText = objData.data.Resume;
		objDisease.ResumeText = objData.data.RelatedResume.RowID;
		objArry.push(objDisease);
		//a();
	}
	return objArry;
}

function DisplayDiseaseList(objArry)
{
	var objItem = null;
	var objData = null;
	var objICD = null;
	var objDisResult = null;
	var objDiagnoseType = null;
	var data = objGridDisease.getStore();
	if (objArry.length>0){data.removeAll();}
	for(var i = 0; i < objArry.length; i ++)
	{
		objItem = objArry[i];
		if(objItem.ItemTypeDr != objDiseaseType.RowID)
			continue;
		objICD = GetDHCWMRDiseaseICDDxByID("MethodGetDHCWMRDiseaseICDDxByID", objItem.ICDDr);
		//objDisResult = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItem.Result);
		//update by zf 2008-07-02
		//objResume = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItem.ResumeText);
		//update by LiYang 2008-07-22 
		//In friendship hospital, "ResumeText" Filed is empty so it will lead a runtime error about null pointer.
		//if objResume point to null, i will create a new Dictionary Object.
		//if(objResume == null)
		//	objResume = new DHCWMRDictionary();
		//if((objItem.FPICDType != "") && (objItem.FPICDType != null)){
		//	objDiagnoseType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItem.FPICDType);
		//}else{
		//	objDiagnoseType = new DHCWMRDictionary();
		//}
		var objResume = new DHCWMRDictionary();
		if (objItem.ResumeText!=="")
		{
			objResume = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItem.ResumeText);
		}
		var objDisResult = new DHCWMRDictionary();
		if ((objItem.Result!="")&&(objItem.Result!=0))   ///modify by liulan 20131022
		{
			objDisResult = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItem.Result);
		}
		var objDiagnoseType = new DHCWMRDictionary();
		if ((objItem.FPICDType != "") && (objItem.FPICDType != null))
		{
			objDiagnoseType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItem.FPICDType);
		}
		objData =new Ext.data.Record({
			RowID:objItem.RowID,
			ICDCode:objICD.ICD,
			ICDDescription:objICD.Name,
			DiseaseResult:objDisResult.Description,
			RelatedICDDic:objICD,
			RelatedDisResultDic:objDisResult,
			Position:objItem.Pos,        
			DiagnoseType:objDiagnoseType.Description,
			RelatedDiagnoseType:objDiagnoseType,
			//update by zf 2008-07-02
			//Resume:objItem.ResumeText
			Resume:objResume.Description,
			RelatedResume:objResume
		});         
		data.add([objData]);
	}
	//data.sort("Position", "ASC");
	SelectFirstComboBoxItem(txtDiseaseResume);
}

function DisplayHISDiagnose(Paadm)
{
	var arryDiagnose = QueryAdmitDiagnose("MethodQueryAdmitDiagnose", Paadm);
	var objRec = null;
	var objDis = null;
	var arryData = new Array();
	var objStore = objGridHisDisease.getStore();
	for(var i = 0; i < arryDiagnose.length; i ++)
	{
		objDis = arryDiagnose[i];
		objRec = new Ext.data.Record({
			RowID:objDis.ICDRowID,
			ICDCode:objDis.ICD,
			ICDDescription:objDis.DiagnoseName,
			DiagnoseType:objDis.DiagnoseTypeDesc,
			DoctorCode:objDis.Doctor.Code,
			Doctor:objDis.Doctor.UserName,
			DiagnoseDate:objDis.DiagnoseDate,
			DiagnoseTime:objDis.DiagnoseTime,
			objAdmitDiagnose:objDis,
			Resume:objDis.ResumeText,
			objRepDiagnose:null,
			DischargeState:objDis.DischargeState    //add by zf 2008-06-10
		});
		objStore.add([objRec]);
	}
	
	if (GetParam(window, "UseHisDiagnose") != "Y")
		return;
	var objDisStore = objGridDisease.getStore();
	if (objDisStore.getCount()>0)
		return;
	var objICD = null;
	var objDisResult = null;
	var objDiagnoseType = null;
	var objResume = null;
	var objData = null;
	var objDic = null;
	
	var arryICDType = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "FPICDType", "Y");
	var arryDiseaseResult = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "DiseaseResult", "Y");
	var arryResume = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "QuestionDiagnose", "Y");
	for (var i = 0; i < arryDiagnose.length; i++) {
		objDis = arryDiagnose[i];
		objICD=GetDHCWMRDiseaseICDDxByID("MethodGetDHCWMRDiseaseICDDxByID",objDis.ICDRowID);
		if (objICD==null)
		{
			objICD = new DHCWMRICDDx();
			//objICD.RowID = objDis.ICDRowID;
			//objICD.ICD = objDis.ICD;
			objICD.Name = objDis.DiagnoseName;
		}
		
		objDiagnoseType=null;
		for (var Ind=0;Ind<arryICDType.length;Ind++)
		{
			objDic=arryICDType[Ind];
			if (objDis.DiagnoseTypeDesc==objDic.Description){objDiagnoseType=objDic;}
		}
		if (objDiagnoseType==null){objDiagnoseType = new DHCWMRDictionary();}
		
		objDisResult=null;
		for (var Ind=0;Ind<arryDiseaseResult.length;Ind++)
		{
			objDic=arryDiseaseResult[Ind];
			if (objDis.DischargeState==objDic.Description){objDisResult=objDic;}
		}
		if (objDisResult==null){objDisResult = new DHCWMRDictionary();}
		
		objResume=null;
		for (var Ind=0;Ind<arryResume.length;Ind++)
		{
			objDic=arryResume[Ind];
			if (objDic.Code=="1"){objResume=objDic;}
		}
		if (objResume==null){objResume = new DHCWMRDictionary();}
		
		objData = new Ext.data.Record({
			RowID: "",
			ICDCode: objICD.ICD,
			ICDDescription: objICD.Name,
			DiseaseResult: objDisResult.Description,
			RelatedICDDic: objICD,
			RelatedDisResultDic: objDisResult,
			Position: objDisStore.getCount(),
			DiagnoseType: objDiagnoseType.Description,
			RelatedDiagnoseType: objDiagnoseType,
			Resume: objResume.Description,
			RelatedResume: objResume
		});
		objDisStore.add(objData);
	}
	if (objDisStore.getCount()>0)
	{
		for (var i=0;i<arryICDType.length;i++)
		{
			objDic = arryICDType[i];
			if (objDic.Code == "2"){cboDiseaseType.setValue(objDic.RowID);}
		}
	}
}


//Add By LiYang Select ComboBox Value
function GetValueFromCombo(objCombo, Code) {
    var objStore = objCombo.initialConfig.store;
    if (objStore.getCount() == 0)
        return null;
    var objValue = null;
    var objRec = null;
    var obj = null;
    for (var i = 0; i < objStore.getCount(); i++) {
        objRec = objStore.getAt(i);
        obj = objRec.get("Obj");
        if (obj.Code == Code) {
            return obj.RowID;
        }
    }
    return null;
}

//Add By LiYang 2009-05-16
//Get Record Object from Grid
function GetGridSelectedData(objGrid) 
    {
        var objSel = objGrid.getSelectionModel();
        var objData = null;
        if(objSel.selections.items.length > 0)
        {
    	    objData = objSel.selections.items[0];
        }
	return objData;
    } 
    
Ext.grid.CheckColumn = function(config){
    Ext.apply(this, config);
    if(!this.id){
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype ={
    init : function(grid){
        this.grid = grid;
        this.grid.on('render', function(){
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },

    onMouseDown : function(e, t){
        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
            e.stopEvent();
            var index = this.grid.getView().findRowIndex(t);
            var record = this.grid.store.getAt(index);
            record.set(this.dataIndex, !record.data[this.dataIndex]);
            record.commit();
        }
    },

    renderer : function(v, p, record){
        p.css += ' x-grid3-check-col-td'; 
        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
};

    
    
