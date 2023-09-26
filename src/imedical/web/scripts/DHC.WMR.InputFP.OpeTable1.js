
var strInputOpe = t["strName"];
var strOperationGridTitle=t["strOperationGridTitle"];
var strOperationICD=t["strOperationICD"];
var strOperationName=t["strOperationName"];
var strOperationDate=t["strOperationDate"];
var strOperattor=t["strOperattor"];
var strAssistant1=t["strAssistant1"];
var strAssistant2=t["strAssistant2"];
var strNarcosisType=t["strNarcosisType"];
var strNarcosisDoctor=t["strNarcosisDoctor"];
var strCloseUp=t["strCloseUp"];
var strDiseaseCode = t["strDiseaseCode"];
var strDiseaseResult = t["strDiseaseResult"];
var strMsgInputICDCode = t["strMsgInputICDCode"];
var strMsgInputDiseaseResult = t["strMsgInputDiseaseResult"];
var strMsgInputOperationICD = t["strMsgInputOperationICD"];
var strMsgInputOperationDate = t["strMsgInputOperationDate"];
var strMsgInputOperator = t["strMsgInputOperator"];
var strMsgInputAssistant1 = t["strMsgInputAssistant1"];
var strMsgInputAssistant2 = t["strMsgInputAssistant2"];
var strMsgInputNarcosisType = t["strMsgInputNarcosisType"];
var strMsgInputNarcosisDoctor = t["strMsgInputNarcosisDoctor"];
var strMsgInputCloseUpType = t["strMsgInputCloseUpType"];

var objGridOperation = null;
var cboOperationICD = null;
var txtOperationDate = null;
var cboOperator = null;
var cboAssistant1 = null;
var cboAssistant2 = null;
var cboNarcosisType = null;
var cboNarcosisDoctor = null;
var cboCloseUpType = null;
var objGridOrder= null;
var cboOpeType = null;



var arryOpeTblFields = null;
var dicOpeTblFields = new ActiveXObject("Scripting.Dictionary");
var objOperationType = GetDHCWMRDictionaryByTypeCode("MethodGetDHCWMRDictionaryByTypeCode", "ICDType", "O"); //{RowID:48,Code:48,Description:" ÷ ı"};//DHCWMRDictionary of item type 'disease'null;//DHCWMRDictionary of item type 'operation'
var frmOperation = null;


//Ext.onReady(InitDiseaseGrid];

function InitOperationGrid(){
	
	strInputOpe = t["strName"];
	strOperationGridTitle=t["strOperationGridTitle"];
	strOperationICD=t["strOperationICD"];
	strOperationName=t["strOperationName"];
	strOperationDate=t["strOperationDate"];
	strOperattor=t["strOperattor"];
	strAssistant1=t["strAssistant1"];
	strAssistant2=t["strAssistant2"];
	strNarcosisType=t["strNarcosisType"];
	strNarcosisDoctor=t["strNarcosisDoctor"];
	strCloseUp=t["strCloseUp"];
	strDiseaseCode = t["strDiseaseCode"];
	strDiseaseResult = t["strDiseaseResult"];
	strMsgInputICDCode = t["strMsgInputICDCode"];
	strMsgInputDiseaseResult = t["strMsgInputDiseaseResult"];
	strMsgInputOperationICD = t["strMsgInputOperationICD"];
	strMsgInputOperationDate = t["strMsgInputOperationDate"];
	strMsgInputOperator = t["strMsgInputOperator"];
	strMsgInputAssistant1 = t["strMsgInputAssistant1"];
	strMsgInputAssistant2 = t["strMsgInputAssistant2"];
	strMsgInputNarcosisType = t["strMsgInputNarcosisType"];
	strMsgInputNarcosisDoctor = t["strMsgInputNarcosisDoctor"];
	strMsgInputCloseUpType = t["strMsgInputCloseUpType"];
    Ext.QuickTips.init();
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
   
    cboOperationICD = CreateICDDicQueryComboBox("O", strOperationICD);
    txtOperationDate = new Ext.form.DateField({fieldLabel :strOperationDate,format:'Ymd', width:170});
    cboOperator = CreateDicQueryComboBox("DOCTOR", strOperattor);
    cboAssistant1 = CreateDicQueryComboBox("DOCTOR", strAssistant1);
    cboAssistant2 = CreateDicQueryComboBox("DOCTOR", strAssistant2);
    cboNarcosisType = CreateDicQueryComboBox("NarcosisType", strNarcosisType);
    cboNarcosisDoctor = CreateDicQueryComboBox("DOCTOR", strNarcosisDoctor);
    cboCloseUpType = CreateDicQueryComboBox("CloseUp", strCloseUp);
    var xtmp=GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "FPOpeType", "Y");
    cboOpeType = new Ext.form.ComboBox({
    	fieldLabel:t["OpeType"],
    	editable:false,
    	mode: 'local', 
    	triggerAction: 'all',
    	store:CreateDicStore(xtmp,"RowID","Description"),
    	mode:'local',
    	displayField:"Description",
    	valueField:"RowID"
    });
    
    arryOpeTblFields = [
    	cboOperationICD,
		txtOperationDate, 
		cboOperator, 
		cboAssistant1, 
		cboAssistant2,
        cboNarcosisType, 
        cboNarcosisDoctor, 
        cboCloseUpType,
        cboOpeType
    ];
    
    SelectFirstComboBoxItem(cboOpeType);
    cboOperationICD.setWidth(120);
    txtOperationDate.setWidth(120);
    cboOperator.setWidth(120);
    cboAssistant1.setWidth(120);
    cboAssistant2.setWidth(120);
    cboNarcosisType.setWidth(120);
    cboNarcosisDoctor.setWidth(120);
    cboCloseUpType.setWidth(120);
    cboOpeType.setWidth(120);

    var myData = [];

    // create the data store
    var store = new Ext.data.SimpleStore({
        fields: [
           {name: 'RowID'},
           {name: 'ICDCode'},
           {name: 'ICDDescription'},
           {name: 'OperationDate'},
           {name: 'Operator'},
           {name: 'Assistant1'},
           {name: 'Assistant2'},
           {name: 'NarcosisType'},
           {name: 'NarcosisDoctor'},
           {name: 'CloseUp'},
           {name: 'OpeType'},
           {name: 'RelatedICDDic'},
           {name: 'RelatedOperator'},
           {name: 'RelatedAssistant1'},
           {name: 'RelatedAssistant2'},
           {name: 'RelatedNarcosisType'},
           {name: 'RelatedNarcosisDoctor'},
           {name: 'RelatedCloseUp'},
           {name: 'RelatedOpeType'}
           //{name: 'lastChange', type: 'date', dateFormat: 'n/j h:ia'}
        ]
    });
    store.loadData(myData);

    // create the Grid
    var grid = new Ext.grid.GridPanel({
        store: store,
        columns: [
        		new Ext.grid.RowNumberer(),
            {id:'RowID', header: strOperationICD, width: 75, sortable: false, dataIndex: 'ICDCode'},
            {header: strOperationName, width: 120, sortable: false, dataIndex: 'ICDDescription'},
            {header: strOperationDate, width: 75, sortable: false, dataIndex: 'OperationDate'},
            {header: strOperattor, width: 75, sortable: false,  dataIndex: 'Operator'},
            {header: strAssistant1, width: 75, sortable: false, dataIndex: 'Assistant1'},
            {header: strAssistant2, width: 75, sortable: false,  dataIndex: 'Assistant2'},
            {header: strNarcosisType, width: 75, sortable: false, dataIndex: 'NarcosisType'},
            {header: strNarcosisDoctor, width: 75, sortable: false,  dataIndex: 'NarcosisDoctor'},
            {header: strCloseUp, width: 75, sortable: false, dataIndex: 'CloseUp'},
            {header: t["OpeType"], width: 75, sortable: false, dataIndex: 'OpeType'}
        ],
        stripeRows: true,
        height:220,
        width:780,
        tbar: [
        {
            text: strDel,
            handler : RemoveOperation
            }]
    });
    
    objGridOrder = new Ext.grid.GridPanel({
        store: new Ext.data.SimpleStore({
			fields: [
			   {name: 'RowID'},
			   {name: 'OperationName'},
			   {name: 'EmergencyOperation'},
			   {name: 'OrderDate'},
			   {name: 'OrderStatus'},
			   {name: 'StartDate'},
			   {name: 'StartTime'},
			   {name: 'EndDate'},
			   {name: 'EndTime'},
			   {name: 'Operator'},
			   {name: 'NarcosisType'},
			   {name: 'CutType'},
			   {name: 'CloseType'},
			   {name: 'CloseTypeObj'},
			   {name: 'CutInfected'},
			   {name: 'OpeCutType'},
			   {name: 'CauseInfection'},
			   {name: 'objOpeInfo'},
			   {name: 'objRepOpe'},
			   {name: 'OperatorObj'},
			   {name: 'NarcosisTypeObj'},
			   {name: 'CutTypeObj'},
			   {name: 'OpeCutTypeObj'},
			   {name: 'OpStartTime'},
			   {name: 'OpEndTime'},
			   {name: 'OpeCutTypeObj'},
			   {name: 'checked'},
			   {name: 'pChange'},
			   {name: 'OpICD'},
			   {name: 'OperatorObj'}
			]
		}),
        columns: [
						new Ext.grid.RowNumberer(),
						{id:'RowID', header: 'ICD', width: 75, sortable: false,  dataIndex: 'OpICD'},
            {header: strOperationName, width: 75, sortable: false, dataIndex: 'OperationName'},
            {header: strOperationDate, width: 75, sortable: false,  dataIndex: 'StartDate'},
						{header: strOperattor, width: 75, sortable: false,  dataIndex: 'Operator'},
            {header: strNarcosisType, width: 75, sortable: false,  dataIndex: 'NarcosisType'}
        ],
        stripeRows: true,
        height:150,
        width:780
    }); 
    
            
        // turn on validation errors beside the field globally
        Ext.form.Field.prototype.msgTarget = 'side';
        var objSetting = {
            labelAlign: 'left',
            frame:true,
            bodyStyle:'padding:5px 5px 0',
            width: 800,
            renderTo:"OperationGrid",
            items: [

                {layout:'form', 
                 items:[
                 		objGridOrder,
                 		grid,
   									//new Ext.Panel
   									( 
   										{
   											frame:true,
   											title:strOperationGridTitle,
                        xtype:'fieldset',
                        //autoHeight:true,
                        defaults: {width: 800},
                        //defaultType: 'textfield',
                        items:[
                        		{
                        			layout:'column',
                        			items:[
                        				{
					                      	columnWidth:.3,
									                layout: 'form',
									                items: [cboOperationICD,cboAssistant1,cboNarcosisDoctor]
					                      },
					                      {
					                      	columnWidth:.3,
									                layout: 'form',
									                items: [txtOperationDate,cboAssistant2,cboCloseUpType]
					                      },
					                      {
					                      	columnWidth:.3,
									                layout: 'form',
									                items: [cboOperator,cboNarcosisType,cboOpeType]
					                      }
                        			]	
                        		}
                        ]
   										}
   									)
                ]
              }
            ]
        };
        //var bd = Ext.getBody();
        //a();
        
    
    frmOperation = new Ext.FormPanel(objSetting);
    objGridOperation = grid;
    initOperationTableEvent(); 
}

function initOperationTableEvent()
{
    var obj = null;
    for(var i = 0; i < arryOpeTblFields.length; i ++)
    {
        obj = arryOpeTblFields[i];
        obj.on('specialkey', OperationTableEventHandler, obj);
        dicOpeTblFields.Add(arryOpeTblFields[i].getId(), arryOpeTblFields[i]);
    }
    
}

function AddOperation()
{
    var data = objGridOperation.getStore();
    var objICD = GetDHCWMROperationICDDxByID("MethodGetDHCWMROperationICDDxByID", cboOperationICD.getValue());;
    var objDicOperator = null;
    var objDicAssistant1 = null;
    var objDicAssistant2 = null;
    var objDicNarcosisType = null;//objDicNarcosisType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboNarcosisType.getValue());
    var objDicNarcosisDoctor = null;
    var objDicCloseUp = null;//GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboCloseUpType.getValue());
	var objDicOpeType = null;

    if(cboNarcosisType.getValue() != "")
    	objDicNarcosisType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboNarcosisType.getValue());
    else
    	objDicNarcosisType = DHCWMRDictionary(); 
    
    if(cboCloseUpType.getValue() != "")
    	objDicCloseUp = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboCloseUpType.getValue());
    else
    	objDicCloseUp = DHCWMRDictionary();    
    
    if(cboOperator.getValue() != "")
    	objDicOperator = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboOperator.getValue());
    else
    	objDicOperator = DHCWMRUser();
    
    if(cboAssistant1.getValue() != "")
    	objDicAssistant1 = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboAssistant1.getValue());
    else
    	objDicAssistant1 = DHCWMRUser();    

    if(cboAssistant2.getValue() != "")
    	objDicAssistant2 = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboAssistant2.getValue());
    else
    	objDicAssistant2 = DHCWMRUser();    
    	
    if(cboNarcosisDoctor.getValue() != "")
    	objDicNarcosisDoctor = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboNarcosisDoctor.getValue());
    else
    	objDicNarcosisDoctor = DHCWMRUser();        
    
    if(cboOpeType.getValue() != "")
    	objDicOpeType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboOpeType.getValue());
    else
    	objDicOpeType = new DHCWMRDictionary();
    
    
    var objData =new Ext.data.Record({
        RowID : "",
        ICDCode : objICD.ICD,
        ICDDescription : objICD.Name,
        OperationDate : txtOperationDate.getValue().format("Y-m-d"),
        Operator : objDicOperator.UserName,
        Assistant1 : objDicAssistant1.UserName,
        Assistant2 : objDicAssistant2.UserName,
        NarcosisType : objDicNarcosisType.Description,
        NarcosisDoctor : objDicNarcosisDoctor.UserName,
        CloseUp : objDicCloseUp.Description,
        RelatedICDDic : objICD,
        RelatedOperator : objDicOperator,
        RelatedAssistant1 : objDicAssistant1,
        RelatedAssistant2 : objDicAssistant2,
        RelatedNarcosisType : objDicNarcosisType,
        RelatedNarcosisDoctor : objDicNarcosisDoctor,
        RelatedCloseUp : objDicCloseUp,
        OpeType : objDicOpeType.Description,
        RelatedOpeType : objDicOpeType
    });
    //objData.set("RowID", "jhjhjg");
    data.add([objData]);
    //data.removeAll();
   // a();
}

function RemoveOperation()
{
    var objSelModel = objGridOperation.getSelectionModel();
    var data = objGridOperation.getStore();
    var strDelID = "";
    //a();
    if(objSelModel.getCount() > 0)
    {
    		strDelID = objSelModel.getSelected().data.RowID;
    		if(strDelID != "")
    			strDelstr += strDelID  + CHR_1;
        data.remove(objSelModel.getSelected());
    }
}

//handle the event of operation grid input
function OperationTableEventHandler(objSrc, objEvent)
{
    var obj = null;
    var keyCode = objEvent.getKey();  
    for(var i = 0; i < arryOpeTblFields.length; i ++)
    {
        obj = arryOpeTblFields[i];
        if(obj.getId() == objSrc.getId())
            break;
    }
    
    switch(keyCode)
    {
        case objEvent.RETURN:
        case objEvent.ENTER:
            if(i < arryOpeTblFields.length-1)
            {
                arryOpeTblFields[i+1].focus();
            }
            else
            {
            		if(cboOperationICD.getValue() == "")
            		{
            			btnSave.focus();
            			return;
            		}else
            		{
	                if(ValidateInputOperation())//Validate Data
	                {
	                    AddOperation(); //add operation data to the grid
	                    ClearOperationTableInputControl();//clear user input 
	                    cboOperationICD.focus();
	                }
	              }
            }
            
            break;
        case objEvent.UP:
            if(i > 0)
            {
                arryOpeTblFields[i-1].focus();
            }
            break;
        default:
            //window.alert(objEvent.keyCode);
            break; 
                  
    }
}


function ValidateInputOperation()
{
	
		switch(objHospital.MyHospitalCode) //Get Hospital Code
		{
			//case "BeiJing_YY":
			default:
			    if(cboOperationICD.getValue() == "")
			    {
			        window.alert(strMsgInputOperationICD);//Ext.MessageBox.show({title: strNoticeTitle, msg: strMsgInputOperationICD, buttons: Ext.MessageBox.OK});  
			        cboOperationICD.focus();
			        return false;
			    }
			    if(txtOperationDate.getValue() == "")
			    {
			        window.alert(strMsgInputOperationDate); //Ext.MessageBox.show({title: strNoticeTitle, msg: strMsgInputOperationDate, buttons: Ext.MessageBox.OK});  
			        txtOperationDate.focus();
			        return false;
			    }
			    if(cboOperator.getValue() == "")
			    {
			        window.alert(strMsgInputOperator);   //Ext.MessageBox.show({title: strNoticeTitle, msg: strMsgInputOperator, buttons: Ext.MessageBox.OK});   
			        cboOperator.focus();
			        return false;
			    }	
			    if(cboNarcosisType.getValue() == "")
			    {
			        window.alert(strMsgInputNarcosisType);//Ext.MessageBox.show({title: strNoticeTitle, msg: strMsgInputNarcosisType, buttons: Ext.MessageBox.OK});   
			        cboNarcosisType.focus();
			        return false;
			    } 		    
			    if(cboCloseUpType.getValue() == "")
			    {
			        window.alert(strMsgInputCloseUpType);//, msg: strMsgInputCloseUpType, buttons: Ext.MessageBox.OK});   
			        cboCloseUpType.focus();
			        return false;
			    }         
			    if(!txtOperationDate.isValid(false))
			    {
			    	window.alert(strMsgInputOperationDate);
			    	txtOperationDate.focus();
			    	return false;
			    }
			    var tmpOpeDate = txtOperationDate.getValue().format("Y-m-d");
			    /*
			    if((tmpOpeDate < objCurrAdm.AdmitDate) || (tmpOpeDate > objCurrAdm.DisDate))
			    {
			    	window.alert(strMsgInputOperationDate);
			    	txtOperationDate.focus();
			    	return false;    	
			    }
			    */
				break;
		}
	

    /*if(cboAssistant1.getValue() == "")
    {
        Ext.MessageBox.show({title: strNoticeTitle, msg: strMsgInputAssistant1, buttons: Ext.MessageBox.OK});   
        cboAssistant1.focus();
        return false;
    }
    if(cboAssistant2.getValue() == "")
    {
        Ext.MessageBox.show({title: strNoticeTitle, msg: strMsgInputAssistant2, buttons: Ext.MessageBox.OK});   
        cboAssistant2.focus();
        return false;
    }   */
    /*  
    if(cboNarcosisDoctor.getValue() == "")
    {
        Ext.MessageBox.show({title: strNoticeTitle, msg: strMsgInputNarcosisDoctor, buttons: Ext.MessageBox.OK});   
        cboNarcosisDoctor.focus();
        return false;
    }*/       

    return true; 
}

//Clear user input
function ClearOperationTableInputControl()
{
    cboOperationICD.setValue("");
    txtOperationDate.setValue("");
    cboOperator.setValue("");
    cboAssistant1.setValue("");
    cboAssistant2.setValue("");
    cboNarcosisType.setValue("");
    cboNarcosisDoctor.setValue("");
    cboCloseUpType.setValue("");
}

function GetOperationList()
{
    var objArry = new Array();
    var objStore = objGridOperation.getStore();
    var objData = null;
    var objOpe = null;
    for(var i = 0; i < objStore.getCount(); i ++)
    {
        objData = objStore.getAt(i);
        objOpe = DHCWMRFPICD();
        objOpe.RowID = objData.data.RowID;
        objOpe.ICDDr = objData.data.RelatedICDDic.RowID;
        objOpe.Operator = objData.data.RelatedOperator.RowID;
        objOpe.AssistantDr1 = objData.data.RelatedAssistant1.RowID;
        objOpe.AssistantDr2 = objData.data.RelatedAssistant2.RowID;
        objOpe.NarcosisType = objData.data.RelatedNarcosisType.RowID;
        objOpe.NarcosisDoctorDr = objData.data.RelatedNarcosisDoctor.RowID;
        objOpe.CloseUp = objData.data.RelatedCloseUp.RowID;
        objOpe.Pos = i + 1;
        objOpe.ItemTypeDr = objOperationType.RowID;
        objOpe.OperationDate = objData.data.OperationDate;
        objOpe.FPICDType = objData.get("RelatedOpeType").RowID;
        objArry.push(objOpe);
    }
    return objArry;
}

function DisplayOperationList(objArry)
{
    var objData = null;
    var objStore = objGridOperation.getStore();
    var objItm = null;
    var objICD = null;
    //var objDicOperator = null;
    //var objDicAssistant1 = null;
    //var objDicAssistant2 = null;
    var objDicNarcosisType = null;
    //var objDicNarcosisDoctor = null;
    var objDicCloseUp = null;
    var objDicOpeType = null;
    for(var i = 0; i < objArry.length; i ++)
    {
        objItm = objArry[i];
        if(objItm.ItemTypeDr != objOperationType.RowID)
        	continue;
        objICD = GetDHCWMROperationICDDxByID("MethodGetDHCWMROperationICDDxByID", objItm.ICDDr);
        //if(objItm.Operator != "")
        //	objDicOperator = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", objItm.Operator);
        //else
        //	objDicOperator = DHCWMRUser();
        	
       	//if(objItm.AssistantDr1 != "")
        //	objDicAssistant1 = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", objItm.AssistantDr1);
        //else
        //	objDicAssistant1 = DHCWMRUser();
        	
       	//if(objItm.AssistantDr2 != "")
        //	objDicAssistant2 = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", objItm.AssistantDr2);
        //else
        //	objDicAssistant2 = DHCWMRUser();
        	
        if(objItm.FPICDType != "")
        	objDicOpeType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItm.FPICDType);
        else
        	objDicOpeType = new DHCWMRDictionary();
        
        if(objItm.NarcosisType != "")
        	objDicNarcosisType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItm.NarcosisType);
        else
        	objDicNarcosisType = new DHCWMRDictionary();
        	
        //if(objItm.NarcosisDoctorDr != "")
        //	objDicNarcosisDoctor = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", objItm.NarcosisDoctorDr);
        //else
        //	objDicNarcosisDoctor = new DHCWMRUser();       
        	
        if(objItm.CloseUp != "")
        	objDicCloseUp = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItm.CloseUp);
        else
        	objDicCloseUp = new DHCWMRDictionary();              
       
        objData =  new Ext.data.Record({
            RowID : objItm.RowID,
            ICDCode : objICD.ICD,
            ICDDescription : objICD.Name,
            OperationDate : objItm.OperationDate,
            Operator : objItm.OperatorObj.UserName,
            Assistant1 : objItm.AssistantDr1Obj.UserName,
            Assistant2 : objItm.AssistantDr2Obj.UserName,
            NarcosisType : objDicNarcosisType.Description,
            NarcosisDoctor : objItm.NarcosisDoctorDrObj.UserName,
            CloseUp : objDicCloseUp.Description,
            RelatedICDDic : objICD,
            RelatedOperator : objItm.OperatorObj,
            RelatedAssistant1 : objItm.AssistantDr1Obj,
            RelatedAssistant2 : objItm.AssistantDr2Obj,
            RelatedNarcosisType : objDicNarcosisType,
            RelatedNarcosisDoctor : objItm.NarcosisDoctorDrObj,
            RelatedCloseUp : objDicCloseUp,
            OpeType : objDicOpeType.Description,
            RelatedOpeType : objDicOpeType
        });
        objStore.add([objData]);
    }   

}

function ClearOperationList()
{
    var objStore = objGridOperation.getStore();
    objStore.removeAll(); 
    objGridOrder.getStore().removeAll();
}


function DisplayHISOperation(Paadm)
{
	var arry = QueryAdmitOperation("MethodQueryAdmitOperation", Paadm);
	var objRec = null;
	var obj = null;
	var arryData = new Array();
	var objStore = objGridOrder.getStore();
	for(var i = 0; i < arry.length; i ++)
	{
		obj = arry[i];
		objRec = new Ext.data.Record({
			   RowID:obj.OperationRowID,
			   OperationName:obj.OperationName,
			   EmergencyOperation:"",
			   OrderDate:obj.OrderDate,
			   OrderStatus:obj.Status,
			   StartDate:obj.StartDate,
			   StartTime:obj.StartTime,
			   EndTime:obj.EndDate,
			   EndDate:obj.EndTime,
			   Operator:obj.OperDoc,
			   OperatorObj:new DHCMedDoctor(),
			   NarcosisType:obj.Anamed,
			   NarcosisTypeObj:new DHCMedDictionaryItem(),
			   CutType:"",
			   CutTypeObj:new DHCMedDictionaryItem(),
			   CloseType:"",
			   CloseTypeObj:new DHCMedDictionaryItem(),
			   CutInfected:"",
			   OperationCutInfected:"",
			   CauseInfection:"",
			   objOpeInfo:obj,
			   objRepOpe:	null,
			   Day:"",
			   Minute:"",
			   Hour:"",
			   After:"",
			   OpeCutType:"",
			   OpeCutTypeObj:new DHCMedDictionaryItem(),
			   checked:false,
			   OpICD:obj.OPICD9Map
	  });
		objStore.add([objRec]);	
	}	
}