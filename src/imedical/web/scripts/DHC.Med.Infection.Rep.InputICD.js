function InfectionInputICD(objParent, arryDis, arryOpe, evhandler)
{
	var obj = new Object();


	obj.gridDisease = new Ext.grid.GridPanel({
		store: new Ext.data.SimpleStore({
			fields: [
				{name: 'RowID'},
				//{name: 'ICD'},
				{name: 'DiseaseName'},
				{name: 'ICDCode'},
				{name: 'ICDDesc'},
				{name: 'RepObj'}
			]
		}),
	        columns: [
			new Ext.grid.RowNumberer(),
			//{id:'RowID', header: "ICD", width: 75, sortable: false, dataIndex: 'ICD'},
			{header: DiseaseName, width: 200, sortable: false, dataIndex: 'DiseaseName'},
			{header: "ICD", width: 75, sortable: false,  dataIndex: 'ICDCode'},
			{ header: DiseaseName, width: 200, sortable: false, dataIndex: 'ICDDesc' }
	        ],
	        stripeRows: true,
	        height:190,
	        width:600,
	        title: AdmitDiagnose
	});
	
	obj.gridOperation = new Ext.grid.GridPanel({
		store: new Ext.data.SimpleStore({
			fields: [
				{name: 'RowID'},
				//{name: 'ICD'},
				{name: 'OperationName'},
				{name: 'ICDCode'},
				{name: 'ICDDesc'},
				{name: 'RepObj'}
			]
		}),
	        columns: [
			new Ext.grid.RowNumberer(),
			//{header: "ICD", width: 75, sortable: false, dataIndex: 'ICD'},
			{id:'RowID',  header: OperationName, width: 200, sortable: false, dataIndex: 'OperationName' },
			{header: "ICD", width: 75, sortable: false,  dataIndex: 'ICDCode'},
			{ header: OperationName, width: 200, sortable: false, dataIndex: 'ICDDesc' }
	        ],
	        stripeRows: true,
	        height:190,
	        width:600,
	        title: OperationInfo
	});

	obj.objTab = new Ext.TabPanel({
	        height:400
	    });
	        
	var objDisTab =  obj.objTab.add(obj.gridDisease) ;     
	var objOpeTab = obj.objTab.add(obj.gridOperation) ;

	obj.SelInfDisHandler = function(objSel) {
	    if (objSel == null)
	        return;
	    var objRec = GetGridSelectedData(obj.gridDisease);
	    objRec.set("ICDCode", objSel.get("ICD"));
	    objRec.set("ICDDesc", objSel.get("DiseaseName"));
	    objRec.commit();
	}
	
	obj.SelInfOpeHandler = function(objSel) {
	    if (objSel == null)
	        return;
	    var objRec = GetGridSelectedData(obj.gridOperation);    
	    objRec.set("ICDCode", objSel.get("ICD"));
	    objRec.set("ICDDesc", objSel.get("DiseaseName"));
	    objRec.commit();
	}

function DisplayInfo()
{
	var objDia = null;
	var objOpe = null;
	var objRec = null;
	var objStore = null;
	objStore = obj.gridDisease.getStore();
	for(var i = 0; i < arryDis.length; i ++)
	{
		objDia = arryDis[i];
		objRec = new Ext.data.Record({
			RowID:objDia.RowID,
			//ICD:objDia.ICD10,
			DiseaseName:objDia.DiagDesc,
			ICDCode:objDia.ICD10,
			ICDDesc:objDia.ICD10Desc,
			RepObj:objDia
		});
		objRec.commit();
		objStore.add([objRec]);	
	}	
	
	objStore = obj.gridOperation.getStore();
	for(var i = 0; i < arryOpe.length; i ++)
	{
		objOpe = arryOpe[i];
		objRec = new Ext.data.Record({
				RowID:objOpe.RowID,
				//ICD:,
				OperationName:objOpe.OperationDesc,
				ICDCode:objOpe.OPICD9Map,
				ICDDesc:objOpe.OperICD9Desc,
				RepObj:objOpe
		});
		objRec.commit();
		objStore.add([objRec]);	
	}		
	
	
	
	obj.objTab.setActiveTab(objDisTab);
}



	obj.Win = new Ext.Window({
	    title: QueryDisease,
	    //layout:'form',
	    width: 625,
	    height: 300,
	    closeAction: 'hide',
	    plain: true,
	    //autoHeight: true,
	    //renderTo:"MainPanel",
	    modal: true,
	    items: [
			obj.objTab
	        ],
	    buttons: [
	            {
	                text: strQueryICD,
	                handler: function() {
	                    var objQueryWin = null;
	                    var objRec = null;
	                    if (obj.objTab.getActiveTab() == objDisTab) {
	                    		objRec = GetGridSelectedData(obj.gridDisease)
	                    		if (objRec == null)
	                    			return;
	                        objQueryWin = new SelectInfectionDisease(obj, obj.SelInfDisHandler, -1);
	                        objQueryWin.Win.show();
	                    }
	                    if (obj.objTab.getActiveTab() == objOpeTab) {
	                    		objRec = GetGridSelectedData(obj.gridOperation)
	                    		if (objRec == null)
	                    			return;
	                        objQueryWin = SelectInfectionOperation(obj, obj.SelInfOpeHandler, -1);
	                        objQueryWin.Win.show();	                    			
	                    }

	                }
	            },
	        	{
	        	    text: strOK,
	        	    handler: function() {
									var objRep = null;
									var objDia = null;
									var objOpe = null;
									var objRec = null;
									var objStore = null;
									objStore = obj.gridDisease.getStore();
									for(var i = 0; i < objStore.getCount(); i ++)
									{
										objRec = objStore.getAt(i);
										objRep = objRec.get("RepObj");
										objRep.ICD10 = objRec.get("ICDCode");
										objRep.ICD10Desc = objRec.get("ICDDesc");
										SaveInfectionRepDia("MethodSaveInfectionRepDia", SerializeDHCMedInfectionRepDia(objRep,false));
									}	
									
									objStore = obj.gridOperation.getStore();
									for(var i = 0; i < objStore.getCount(); i ++)
									{
										objRec = objStore.getAt(i);
										objRep = objRec.get("RepObj");
										objRep.OPICD9Map = objRec.get("ICDCode");
										objRep.OperICD9Desc = objRec.get("ICDDesc");
										SaveInfectionRepOpe("MethodSaveInfectionRepOpe", SerializeDHCMedInfectionRepOPR(objRep,false));
									}						
									Ext.Msg.alert(Notice, SaveSuccess);
									obj.Win.close();
	        	    }	        	    
	        	},
	        	{
	        	    text: Cancel,
	        	    handler: function() { obj.Win.hide(); }
	        	}
	        ]
	}); 
	
	
	obj.Win.on("beforeshow", DisplayInfo);
	return obj;
}







