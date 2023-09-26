var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_3=String.fromCharCode(3);

var strInputOpe = "";
var strOperationGridTitle="";
var strOperationICD="";
var strOperationName="";
var strOperationDate="";
var strOperattor="";
var strAssistant1="";
var strAssistant2="";
var strNarcosisType="";
var strNarcosisDoctor="";
var strCloseUp="";
var strDiseaseCode = "";
var strDiseaseResult = "";
var strMsgInputICDCode = "";
var strMsgInputDiseaseResult = "";
var strMsgInputOperationICD = "";
var strMsgInputOperationDate = "";
var strMsgInputOperator = "";
var strMsgInputAssistant1 = "";
var strMsgInputAssistant2 = "";
var strMsgInputNarcosisType = "";
var strMsgInputNarcosisDoctor = "";
var strMsgInputCloseUpType = "";
var strOperationRank="";

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
var cboOperationRank = null;



var arryOpeTblFields = null;
var dicOpeTblFields = new ActiveXObject("Scripting.Dictionary");
var objOperationType = "";
var frmOperation = null;


//Ext.onReady(InitDiseaseGrid];

function InitOperationGrid(){
	objOperationType=GetDHCWMRDictionaryByTypeCode("MethodGetDHCWMRDictionaryByTypeCode", "ICDType", "O"); //{RowID:48,Code:48,Description:"手术"};//DHCWMRDictionary of item type 'disease'null;//DHCWMRDictionary of item type 'operation'
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
	strOperationRank=t["strOperationRank"];
	
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
    cboOperationRank=CreateDicQueryComboBox("OperationRank", strOperationRank);
    
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
        cboOpeType,
        cboOperationRank
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
    cboOperationRank.setWidth(120);
    
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
			   {name: 'OpeCutType'},
			   {name: 'OpStartTime'},
			   {name: 'OpEndTime'},
			   {name: 'OpeCutTypeObj'},
			   {name: 'checked'},
			   {name: 'pChange'},
			   {name: 'OpICD'},
		 	   {name: 'AssDoc1'},
		     {name: 'AssDoc2'},
		     {name: 'AnDoctor'},
			   {name: 'OperatorObj'},
			   {name: 'SrcType'}, //Add By LiYang 2009-07-30
			   {name:'OperationRank'}
			]
		}),
        columns: [
		new Ext.grid.RowNumberer(),
		{id:'RowID', header: 'CM3', width: 75, sortable: false,  dataIndex: 'OpICD'},
		{header: strOperationName, width: 75, sortable: false, dataIndex: 'OperationName'},
		{header: strOperationDate, width: 75, sortable: false,  dataIndex: 'StartDate'},
		{header: strOperattor, width: 75, sortable: false,  dataIndex: 'Operator'},
		{header: strAssistant1, width: 75, sortable: false, dataIndex: 'AssDoc1'},
		{header: strAssistant2, width: 75, sortable: false,  dataIndex: 'AssDoc2'},
		{header: strNarcosisType, width: 75, sortable: false,  dataIndex: 'NarcosisType'},
		{header: strNarcosisDoctor, width: 75, sortable: false,  dataIndex: 'AnDoctor'},
		{header: strCloseUp, width: 75, sortable: false, dataIndex: 'OpeCutType'},
		{header:strOperationRank,width:75,sortable:false,dataIndex:'OperationRank'}
        ],
        stripeRows: true,
        height:150,
        width:980
    }); 
    
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
           {name: 'RelatedOpeType'},
           {name: 'Position'}, //Add By LiYang 2009-5-16 user can change record order
           {name: 'SrcType'}, //Add By LiYang 2009-07-28 Dic Type
           {name:'OperationRank'}
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
            {header: t["OpeType"], width: 75, sortable: false, dataIndex: 'OpeType'},
            {header:strOperationRank,width:75,sortable:false,dataIndex:'OperationRank'}
        ],
        stripeRows: true,
        height:220,
        width:980,
        tbar: [
        {
            text: t["AddFromHis"],
            handler : function()
            {
		var objRec = GetGridSelectedData(objGridOrder);
		if (objRec == null) return;
		var data = objGridOperation.getStore();
		
		var objICD = GetDHCWMROperationICDDxByID("MethodGetDHCWMROperationICDDxByID", objRec.get("RowID"));
		if (objICD==null){
			objICD=new DHCWMRICDDx();
			//objICD.RowID = objRec.get("RowID");
			//objICD.ICD = oobjRec.get("OpICD");
			objICD.Name = objRec.get("OperationName");
		}
		
		var objDicOperator=QueryDoctorByName("MethodQueryDoctorByName",objRec.get("Operator"));
		if (objDicOperator==null){objDicOperator = DHCWMRUser();}
		var objDicAssistant1=QueryDoctorByName("MethodQueryDoctorByName",objRec.get("AssDoc1"));
		if (objDicAssistant1==null){objDicAssistant1 = DHCWMRUser();}
		var objDicAssistant2=QueryDoctorByName("MethodQueryDoctorByName",objRec.get("AssDoc2"));
		if (objDicAssistant2==null){objDicAssistant2 = DHCWMRUser();}
		var objDicNarcosisDoctor=QueryDoctorByName("MethodQueryDoctorByName",objRec.get("AnDoctor"));
		if (objDicNarcosisDoctor==null){objDicNarcosisDoctor = DHCWMRUser();}
		
		var arryNar = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "NarcosisType","Y");
		var arryCloseUp = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "CloseUp","Y");
		var arryOperType = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "FPOpeType","Y");
		var arryOperationRank=GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "OperationRank","Y");
		
		var objDic = null;
		var objDicNarcosisType = null;
		for(var i = 0; i < arryNar.length; i ++)
		{
			objDic = arryNar[i];
			if(objDic.Description == objRec.get("NarcosisType"))
			{
				objDicNarcosisType=objDic;
				break;
			}
		}
		if(objDicNarcosisType == null){objDicNarcosisType = DHCWMRDictionary();}
		
		var objDic=null;
		var objDicCloseUp = null;
		for(var i = 0; i < arryCloseUp.length; i ++)
		{
			objDic = arryCloseUp[i];
			if(objDic.Description==objRec.get("OpeCutType"))
			{
				objDicCloseUp=objDic;
				break;
			}
		}
		if(objDicCloseUp == null){objDicCloseUp = DHCWMRDictionary();}
		
		var objDic=null;
		var objDicOpeType = null;
		for(var i = 0; i < arryOperType.length; i ++){
			objDic = arryOperType[i];
			if(objDic.Code == "1"){
				objDicOpeType = objDic;
				break;
			}
		}
		if(objDicOpeType == null){objDicOpeType = new DHCWMRDictionary();}
		
		var objDic=null;
		var objDicOperationRank = null;
		for(var i = 0; i < arryOperationRank.length; i ++)
		{
			objDic = arryOperationRank[i];
			if(objDic.Description==objRec.get("OperationRank"))
			{
				objDicOperationRank=objDic;
				break;
			}
		}
		if(objDicOperationRank == null){objDicOperationRank = DHCWMRDictionary();}
		
		var objData =new Ext.data.Record({
			RowID : "",
			ICDCode : objICD.ICD,
			ICDDescription : objICD.Name,
			OperationDate : objRec.get("StartDate"),
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
			RelatedOpeType : objDicOpeType,
			SrcType:objRec.get("SrcType"),//Add By LiYang 2009-07-30
			OperationRank:objDicOperationRank.Description
		});
		data.add([objData]);
            }        	
        	
        },
        {
            text: strDel,
            handler : RemoveOperation
        },
				{
					text:t["Up"],  //Add By LiYang 2009-05-16  User Can change record position
					handler:function()
					{
						var objRec = GetGridSelectedData(objGridOperation);
						var objStore = objGridOperation.getStore();
						if (objRec == null)
							return;
						var intPos = objStore.indexOf(objRec);
						if (intPos > 0)
						{
							objStore.remove(objRec);
							objStore.insert(intPos - 1, [objRec]);
						    objGridOperation.getSelectionModel().selectRow(intPos -1);  // add by liulan 2013-10-23 
						}
					}
				},
				{
					text:t["Down"],  //Add By LiYang 2009-05-16  User Can change record position
					handler:function()
					{
						var objRec = GetGridSelectedData(objGridOperation);
						var objStore = objGridOperation.getStore();
						if (objRec == null)
							return;
						var intPos = objStore.indexOf(objRec);
						if (intPos < objStore.getCount())
						{
							objStore.remove(objRec);
							objStore.insert(intPos + 1, [objRec]);
							objGridOperation.getSelectionModel().selectRow(intPos + 1);
						}
					}			
				},
				{
					text:t["SaveToGrid"],  //Add By LiYang 2009-07-23  User Can change record position
					handler:function()
					{
						var objRec = GetGridSelectedData(objGridOperation);
						var objStore = objGridOperation.getStore();
						if (objRec == null)
							return;
						ModifyOperation(objRec);
					}			
				}             
            
        ]
    });
    
            
        // turn on validation errors beside the field globally
        Ext.form.Field.prototype.msgTarget = 'side';
        var objSetting = {
            labelAlign: 'left',
            frame:true,
            bodyStyle:'padding:5px 5px 0',
            width: 1000,
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
                        defaults: {width: 980},
                        //defaultType: 'textfield',
                        items:[
                        		{
                        			layout:'column',
                        			items:[
                        				{
					                      	columnWidth:.3,
									                layout: 'form',
									                items: [cboOperationICD,cboAssistant1,cboNarcosisDoctor,cboOperationRank]
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
    //Add By LiYang 2009-07-23 when user click one grid item, displays it's info
    grid.on("click",
        function() {
            var objRec = GetGridSelectedData(grid);
            if (objRec == null)
                return;
            DisplayOpeRec(objRec);
        }
     );    
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
    var objRec = GetComboSelRecord(cboOperationICD);
    var objICD = GetDHCWMROperationICDDxByID("MethodGetDHCWMROperationICDDxByID", cboOperationICD.getValue(), objRec.get("SrcType"));
    var objDicOperator = null;
    var objDicAssistant1 = null;
    var objDicAssistant2 = null;
    var objDicNarcosisType = null;
    var objDicNarcosisDoctor = null;
    var objDicCloseUp = null;
    var objDicOpeType = null;

    if((cboNarcosisType.getValue() != "") && (cboNarcosisType.getRawValue() != ""))
    	objDicNarcosisType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboNarcosisType.getValue());
    else
    	objDicNarcosisType = DHCWMRDictionary(); 
    
  if((cboCloseUpType.getValue() != "") && (cboCloseUpType.getRawValue() != ""))
    	objDicCloseUp = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboCloseUpType.getValue());
    else
    	objDicCloseUp = DHCWMRDictionary();    
    
    if((cboOperator.getValue() > 0) && (cboOperator.getRawValue() != ""))
    	objDicOperator = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboOperator.getValue());
    else
    {
    	objDicOperator = DHCWMRUser();
    	objDicOperator.UserName = cboOperator.getRawValue();
    }
    
    if((cboAssistant1.getValue() > 0) && (cboAssistant1.getRawValue() != ""))
    	objDicAssistant1 = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboAssistant1.getValue());
    else
    {
    	objDicAssistant1 = DHCWMRUser();
    	objDicAssistant1.UserName = cboAssistant1.getRawValue();    
	}
    if((cboAssistant2.getValue() > 0) && (cboAssistant2.getRawValue() != ""))
    	objDicAssistant2 = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboAssistant2.getValue());
    else
    {
    	objDicAssistant2 = DHCWMRUser();
    	objDicAssistant2.UserName = cboAssistant2.getRawValue();        
    }
    if((cboNarcosisDoctor.getValue() > 0) && (cboNarcosisDoctor.getRawValue() != ""))
    	objDicNarcosisDoctor = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboNarcosisDoctor.getValue());
    else
    {
    	objDicNarcosisDoctor = DHCWMRUser();        
    	objDicNarcosisDoctor.UserName = cboNarcosisDoctor.getRawValue();  
    }
    if(cboOpeType.getValue() != "")
    	objDicOpeType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboOpeType.getValue());
    else
    	objDicOpeType = new DHCWMRDictionary();
    	
    
    if(cboOperationRank.getValue() != "")
    	objDicOperationRank = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboOperationRank.getValue());
    else
    	objDicOperationRank = new DHCWMRDictionary();
    
    
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
        RelatedOpeType : objDicOpeType,
        SrcType:objRec.get("SrcType"),
        OperationRank:cboOperationRank.getRawValue()
    });
    data.add([objData]);
}

//Add By LiYang 2009-07-23 Modify exists operation record
function ModifyOperation(objRec)
{
	if(!ValidateInputOperation()) return;  //add by zf 20100429
    if ((cboOpeType.getRawValue()=="手术")&&((cboOperationICD.getValue()=="")||(cboOperationICD.getRawValue()=="")||(cboOperator.getValue()=="")||(cboOperator.getRawValue()=="")||(txtOperationDate.getValue()=="")))
    {
			alert("手术信息必须录入手术编码、手术日期和术者!");
			return;
    }
    //add by liuxuefeng 2010-04-28 麻醉方式不为空或者不为“无”，必须有麻醉医师
    if ((cboNarcosisType.getRawValue()!="")&&(cboNarcosisType.getRawValue()!="无"))
    {
			if((cboNarcosisDoctor.getValue()=="")||(cboNarcosisDoctor.getRawValue()==""))
			{
				alert("麻醉方式不为空或者不为“无”,必须有麻醉医师!");
				return;
			}
    }
    var data = objGridOperation.getStore();
    var objICD = GetDHCWMROperationICDDxByID("MethodGetDHCWMROperationICDDxByID", cboOperationICD.getValue(),objRec.get("SrcType"));
    if (objICD==null) return;
    var objDicOperator = null;
    var objDicAssistant1 = null;
    var objDicAssistant2 = null;
    var objDicNarcosisType = null;//objDicNarcosisType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboNarcosisType.getValue());
    var objDicNarcosisDoctor = null;
    var objDicCloseUp = null;//GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboCloseUpType.getValue());
    var objDicOpeType = null;
    var objDicOperationRank=null;

    if((cboNarcosisType.getValue() != "") && (cboNarcosisType.getRawValue() != ""))
    	objDicNarcosisType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboNarcosisType.getValue());
    else
    	objDicNarcosisType = DHCWMRDictionary(); 
    
  if((cboCloseUpType.getValue() != "") && (cboCloseUpType.getRawValue() != ""))
    	objDicCloseUp = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboCloseUpType.getValue());
    else
    	objDicCloseUp = DHCWMRDictionary();    
    
    if((cboOperator.getValue() > 0) && (cboOperator.getRawValue() != ""))
    	objDicOperator = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboOperator.getValue());
    else
    {
    	objDicOperator = DHCWMRUser();
    	objDicOperator.UserName = cboOperator.getRawValue();
    }
    
    if((cboAssistant1.getValue() > 0) && (cboAssistant1.getRawValue() != ""))
    	objDicAssistant1 = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboAssistant1.getValue());
    else
    {
    	objDicAssistant1 = DHCWMRUser();
    	objDicAssistant1.UserName = cboAssistant1.getRawValue();    
	}
    if((cboAssistant2.getValue() > 0) && (cboAssistant2.getRawValue() != ""))
    	objDicAssistant2 = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboAssistant2.getValue());
    else
    {
    	objDicAssistant2 = DHCWMRUser();
    	objDicAssistant2.UserName = cboAssistant2.getRawValue();        
    }
    if((cboNarcosisDoctor.getValue() > 0) && (cboNarcosisDoctor.getRawValue() != ""))
    	objDicNarcosisDoctor = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", cboNarcosisDoctor.getValue());
    else
    {
    	objDicNarcosisDoctor = DHCWMRUser();        
    	objDicNarcosisDoctor.UserName = cboNarcosisDoctor.getRawValue();  
    }
    if(cboOpeType.getValue() != "")
    	objDicOpeType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboOpeType.getValue());
    else
    	objDicOpeType = new DHCWMRDictionary();
    if (cboOperationRank.getRawValue()=="一级") cboOperationRank.setValue('348');
    if (cboOperationRank.getRawValue()=="二级") cboOperationRank.setValue('349');
    if (cboOperationRank.getRawValue()=="三级") cboOperationRank.setValue('350');
    if (cboOperationRank.getRawValue()=="四级") cboOperationRank.setValue('351');
    
    if(cboOperationRank.getValue() != "")
    	objDicOperationRank = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", cboOperationRank.getValue());
    else
    	objDicOperationRank = new DHCWMRDictionary();
    	
    objRec.set("ICDCode", objICD.ICD);
    objRec.set("ICDDescription", objICD.Name);
    objRec.set("OperationDate", txtOperationDate.getValue().format("Y-m-d"));
    objRec.set("Operator", objDicOperator.UserName);
    objRec.set("Assistant1", objDicAssistant1.UserName);
    objRec.set("Assistant2", objDicAssistant2.UserName);
    objRec.set("NarcosisType", objDicNarcosisType.Description);
    objRec.set("NarcosisDoctor", objDicNarcosisDoctor.UserName);
    objRec.set("CloseUp", objDicCloseUp.Description);
    objRec.set("RelatedICDDic", null);
    objRec.set("RelatedICDDic", objICD);
    objRec.set("RelatedOperator", null);
    objRec.set("RelatedOperator", objDicOperator);
    objRec.set("RelatedAssistant1", null);
    objRec.set("RelatedAssistant1", objDicAssistant1);
    objRec.set("RelatedAssistant2", null);
    objRec.set("RelatedAssistant2", objDicAssistant2);
    objRec.set("RelatedNarcosisType", null);
    objRec.set("RelatedNarcosisType", objDicNarcosisType);
    objRec.set("RelatedNarcosisDoctor", null);
    objRec.set("RelatedNarcosisDoctor", objDicNarcosisDoctor);
    objRec.set("RelatedCloseUp", null);
    objRec.set("RelatedCloseUp", objDicCloseUp);
    objRec.set("OpeType", null);
    objRec.set("OpeType", objDicOpeType.Description);
    objRec.set("RelatedOpeType", null);
    objRec.set("RelatedOpeType", objDicOpeType);
    objRec.set("OperationRank",null);
    objRec.set("OperationRank",objDicOperationRank.Description);
    objRec.commit();
    	
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
   	        if(cboOperationICD.getRawValue() == '')
       		{
       			//btnSave.focus();
       			break;
       		}
           if(i < arryOpeTblFields.length-1){
                arryOpeTblFields[i+1].focus();
                arryOpeTblFields[i+1].selectText();
            }else{
            		if(cboOperationICD.getValue() == ''){
            			btnSave.focus();
            			return;
            		}else{
            			//alert("BBBBBBBBBBBBBBB");
		                if(ValidateInputOperation())//Validate Data
		                {
		                	//alert("AAAAAAAAAAAAAAAA");
					AddOperation(); //add operation data to the grid
					ClearOperationTableInputControl(true);//clear user input 
					cboOperationICD.focus();
		                }
			}
            }
            break;
        case objEvent.UP:
            if(i > 0)
            {
                arryOpeTblFields[i-1].focus();
                arryOpeTblFields[i-1].selectText();
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
			case "ShenYang_YDYFY":
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
			    var tmpOpeDate = txtOperationDate.getValue().format("Y-m-d");
			    if((tmpOpeDate < objCurrAdm.AdmitDate) || ((tmpOpeDate > objCurrAdm.DisDate) && (objCurrAdm.DisDate != "")))
			    {
			    	window.alert(strMsgInputOperationDate);
			    	txtOperationDate.focus();
			    	return false;
			    }
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
			    //modify by liuxuefeng 2010-04-29
			    //alert(cboOpeType.getRawValue());
			    if((cboOpeType.getRawValue()=="手术")&&(cboOperator.getValue() == ""))
			    {
			        window.alert("手术信息必须录入术者!");   //Ext.MessageBox.show({title: strNoticeTitle, msg: strMsgInputOperator, buttons: Ext.MessageBox.OK});   
			        cboOperator.focus();
			        return false;
			    }	
			    /*if(cboNarcosisType.getValue() == "")
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
			    }         */
			    if(!txtOperationDate.isValid(false))
			    {
			    	window.alert(strMsgInputOperationDate);
			    	txtOperationDate.focus();
			    	return false;
			    }
			    var tmpOpeDate = txtOperationDate.getValue().format("Y-m-d");
			    if(((tmpOpeDate < objCurrAdm.AdmitDate) || (tmpOpeDate > objCurrAdm.DisDate)) && (objCurrAdm.DisDate != ""))
			    {
			    	window.alert(strMsgInputOperationDate);
			    	txtOperationDate.focus();
			    	return false;    	
			    }
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
//KeepBaseInfo:Keep Operator\Assistant etc info for next input
function ClearOperationTableInputControl(KeepBaseInfo)
{
	if(KeepBaseInfo)
	{
		cboOperationICD.setValue("");
	}else{
		cboOperationICD.setValue("");
		txtOperationDate.setValue("");
		cboOperator.setValue("");
		cboAssistant1.setValue("");
		cboAssistant2.setValue("");
		cboNarcosisType.setValue("");
		cboNarcosisDoctor.setValue("");
		cboCloseUpType.setValue("");
		cboOperationRank.setValue("");
	}
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
        objOpe.ResumeText = objData.data.RelatedOperator.UserName + "#" +
		objData.data.RelatedNarcosisDoctor.UserName + "#" +
		objData.data.RelatedAssistant1.UserName + "#" +
		objData.data.RelatedAssistant2.UserName;
        objOpe.SrcType = objData.data.SrcType;
        
        objOpe.OperationRank=objData.data.OperationRank;
        objArry.push(objOpe);
    }
    return objArry;
}

function DisplayOperationList(objArry)
{
	
	var objStore = objGridOperation.getStore();
	if (objArry.length>0){objStore.removeAll();}
	var objData = null;
	var objItm = null;
	var objICD = null;
	var objDicNarcosisType = null;
	var objDicCloseUp = null;
	var objDicOpeType = null;
	var objDicOperationRank=null;
	for(var i = 0; i < objArry.length; i ++)
	{
	        objItm = objArry[i];
	        
	        if(objItm.ItemTypeDr !== objOperationType.RowID)
	        	continue;
	        objICD = GetDHCWMROperationICDDxByID("MethodGetDHCWMROperationICDDxByID", objItm.ICDDr);
	        if (objICD==null)
	        {
	        	alert("Data Error!");
	        	continue;
	        }
	        if(objItm.FPICDType !== "")
	        {
	        	objDicOpeType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItm.FPICDType);
	        }
	        if (objDicOpeType==null){objDicOpeType = new DHCWMRDictionary();}
	        
	        if(objItm.NarcosisType !== "")
	        {
	        	objDicNarcosisType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItm.NarcosisType);
	        }
	        if (objDicNarcosisType==null){objDicNarcosisType = new DHCWMRDictionary();}
	        	
	        if(objItm.CloseUp !== "")
	        {
	        	objDicCloseUp = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItm.CloseUp);
	        }
	        if (objDicCloseUp==null){objDicCloseUp = new DHCWMRDictionary();}
	        
	        if(objItm.OperationRank !== "")
	        {
	        	objDicOperationRank = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objItm.OperationRank);
	        }
	        if (objDicOperationRank==null){objDicOperationRank = new DHCWMRDictionary();}
	       
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
	            RelatedOpeType : objDicOpeType,
	            Position:objItm.Pos,
	            SrcType:objItm.SrcType,
	            OperationRank:objItm.OperationRank
	        });
	        objStore.add([objData]);
	}
	//objStore.sort("Position", "ASC");
	ClearOperationTableInputControl(false);
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
		var AssDoc=obj.assList.split(CHR_3);
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
			   CutType:obj.CutType,         //CutType:"",     update by zf 2008-09-23
			   CutTypeObj:new DHCMedDictionaryItem(),
			   CloseType:obj.CloseType,     //CloseType:"",   update by zf 2008-09-23
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
			   OpeCutType:obj.CutType,     //+"/"+obj.CloseType,   //OpeCutType:"",     update by zf 2008-09-23
			   OpeCutTypeObj:new DHCMedDictionaryItem(),
			   checked:false,
			   OpICD:obj.OPICD9Map,
			   AssDoc1:AssDoc[0],         //add by zf 2008-09-23
			   AssDoc2:AssDoc[1],         //add by zf 2008-09-23
			   AnDoctor:obj.anDoctor,
			   OperationRank:obj.OperationRank
	  });
		objStore.add([objRec]);	
	}
	
	if (GetParam(window, "UseHisOperation") !== "Y")
		return;
	var objOperStore = objGridOperation.getStore();
	if (objOperStore.getCount()>0){return;}
	var arryNar = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "NarcosisType","Y");
	var arryCloseUp = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "CloseUp","Y");
	var arryOperType = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "FPOpeType","Y");
	var arryOperationRank = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "OperationRank","Y");
	for (var ind=0;ind<arry.length;ind++)
	{
		obj = arry[ind];
		var AssDoc=obj.assList.split(CHR_3);
		var objICD = GetDHCWMROperationICDDxByID("MethodGetDHCWMROperationICDDxByID", obj.OperationRowID);
		if (objICD==null){
			objICD=new DHCWMRICDDx();
			//objICD.RowID = objDis.ICDRowID;
			//objICD.ICD = obj.OPICD9Map;
			objICD.Name = obj.OperationName;
		}
		
		var objDicOperator=QueryDoctorByName("MethodQueryDoctorByName",obj.OperDoc);
		if (objDicOperator==null){objDicOperator = new DHCWMRUser();}
		var objDicAssistant1=QueryDoctorByName("MethodQueryDoctorByName",AssDoc[0]);
		if (objDicAssistant1==null){objDicAssistant1 = new DHCWMRUser();}
		var objDicAssistant2=QueryDoctorByName("MethodQueryDoctorByName",AssDoc[1]);
		if (objDicAssistant2==null){objDicAssistant2 = new DHCWMRUser();}
		var objDicNarcosisDoctor=QueryDoctorByName("MethodQueryDoctorByName",obj.anDoctor);
		if (objDicNarcosisDoctor==null){objDicNarcosisDoctor = new DHCWMRUser();}
		
		var objDic = null;
		var objDicNarcosisType = null;
		for(var i = 0; i < arryNar.length; i ++){
			objDic = arryNar[i];
			if(objDic.Description == obj.Anamed)
			{
				objDicNarcosisType = objDic;
				break;
			}
		}
		if(objDicNarcosisType == null){objDicNarcosisType = new DHCWMRDictionary();}
		
		var objDic=null;
		var objDicCloseUp = null;
		var txtCloseUp=obj.CutType;   //+"/"+obj.CloseType;
		for(var i = 0; i < arryCloseUp.length; i ++){
			objDic = arryCloseUp[i];
			if(objDic.Description == txtCloseUp){
				objDicCloseUp = objDic;
				break;
			}
		}
		if(objDicCloseUp==null){objDicCloseUp = new DHCWMRDictionary();}
		
		var objDic=null;
		var objDicOpeType = null;
		for(var i = 0; i < arryOperType.length; i ++){
			objDic = arryOperType[i];
			if(objDic.Code == "1"){
				objDicOpeType = objDic;
				break;
			}
		}
		if(objDicOpeType == null){objDicOpeType = new DHCWMRDictionary();}
		
		var objDic = null;
		var objDicOperationRank = null;
		for(var i = 0; i < arryOperationRank.length; i ++){
			objDic = arryOperationRank[i];
			
			if(objDic.Description == obj.OperationRank)
			{
				objDicOperationRank = objDic;
				break;
			}
		}
		
		if(objDicOperationRank == null){objDicOperationRank = new DHCWMRDictionary();}
		
		var objData =new Ext.data.Record({
			RowID : "",
			ICDCode : objICD.ICD,
			ICDDescription : objICD.Name,
			OperationDate : obj.OrderDate,
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
			RelatedOpeType : objDicOpeType,
			SrcType:"",
			OperationRank:objDicOperationRank.Description
		});
		objOperStore.add([objData]);
		//*************************************************************
	}
}