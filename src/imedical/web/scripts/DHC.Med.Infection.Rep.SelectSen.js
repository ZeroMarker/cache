function SelectGermSen(objArry, LabTestRow)
{
	var obj = new Object();
	//LabTestRow = "351950||M030||1" ;
	obj.dicSen = new ActiveXObject("Scripting.Dictionary");
	obj.cboGerm = new Ext.form.ComboBox({fieldLabel:Germ,editable:true,mode: 'local', triggerAction: 'all',store:CreateGermDataStore(),displayField:"Description",valueField:"Code",width:300});
	
	obj.cboGerm.on(
		"select",
		function(){
			var objGerm = GetDicComboValue(obj.cboGerm);
			//return;
			if(objGerm.Resume=="")return;
			var objSelectAntiByPathogen = new SelectAntiByPathogen(obj, obj.AddAntiByPyHandler,objGerm);
			objSelectAntiByPathogen.Win.show();
			},
		obj
	);
	
	obj.cboDrug = new Ext.form.ComboBox({fieldLabel:AntiDrug,editable:true,mode: 'local', triggerAction: 'all',store:CreateAntiDicDataStore(),displayField:"Description",valueField:"Code",width:300});
	//obj.chkSen = new Ext.form.Checkbox({fieldLabel:Sen});
	obj.cboSen = new Ext.form.ComboBox({fieldLabel:Sen,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionLabSenCheck"),displayField:"Description",valueField:"Code",width:80});
	
	obj.gridSenTest = new Ext.grid.GridPanel({
	        store: new Ext.data.SimpleStore({
			fields: [
			   {name: 'RowID'},
			   {name: 'Germ'},
			   {name: 'Drug'},
			   {name: 'Sen'}
			]
		}),
	        columns: [
			new Ext.grid.RowNumberer(),
			{id:'RowID', header: Germ, width: 300, sortable: false, dataIndex: 'Germ'},
			{header: AntiDrug, width: 250, sortable: false, dataIndex: 'Drug'},
			{header: Sen, width: 50, sortable: false,  dataIndex: 'Sen'}
	        ],
	        stripeRows: true,
	        height:150,
	        width:680
    	}); 
    	
	obj.gridSen = new Ext.grid.GridPanel({
	        store: new Ext.data.SimpleStore({
			fields: [
			   {name: 'RowID'},
			   {name: 'Germ'},
			   {name: 'Drug'},
			   {name: 'Sen'},
			   {name: 'GermObj'},
			   {name: 'DrugObj'},
			   {name: 'SenObj'},
			   {name: 'HISLab'}
			]
		}),
	        columns: [
			new Ext.grid.RowNumberer(),
			{id:'RowID', header: Germ, width: 300, sortable: false, dataIndex: 'Germ'},
			{header: AntiDrug, width: 250, sortable: false, dataIndex: 'Drug'},
			{header: Sen, width: 50, sortable: false,  dataIndex: 'Sen'}
	        ],
	        stripeRows: true,
	        height:150,
	        width:680
	}); 
	
	obj.DisplayMapping = function(arry)
	{
  		var objRec = null;
		var objGermDic = null;
  		var objDrugDic = null;
  		var strKey = "";
  		var arryFields = null;
  		for(var i = 0; i < arry.length ; i ++)
  		{
	 		if(arry[i] == "")
	 			continue;
	 		arryFields = arry[i].split(CHR_Up);
	 		objGermDic = GetDicValueFromCombo(obj.cboGerm, 'RowID', arryFields[0]);
	 		objDrugDic = GetDicValueFromCombo(obj.cboDrug, 'RowID', arryFields[1]);
	 		strKey = "R" + objGermDic.RowID + "-" + objDrugDic.RowID;
	 		if(!obj.dicSen.Exists(strKey))
	 		{
	 			objRec = new Ext.data.Record({
				  	RowID : "",
				  	Germ : objGermDic.Desc,
				  	Drug : objDrugDic.Desc,
				  	//Sen : (arryFields[2] == strSen ? "Yes" : "No"),
				  	Sen : arryFields[2],
				  	GermObj : objGermDic,
				  	DrugObj : objDrugDic,
				  	HISLab : false
				});
				obj.gridSen.getStore().add([objRec]);            				
				obj.dicSen.Add(strKey, objRec);
          		}
  		}
	};
	
	if((LabTestRow != null) && (LabTestRow != ""))
	{
   		var arryLab = GetMic("MethodGetMic", LabTestRow); 
   		//Comm_"^"_antname_"^"_temreport_"^"_temres_"^"_temmic_"^"_temmm
   		//arryLab.GermNme = Comm;
		//arryLab.AntiName = antname;
		//arryLab.IsSen = temres;
   		var objItem = null;
		var objRec = null;
		for(var i = 0; i < arryLab.length; i ++)
		{
   	  		objItem = arryLab[i];
			objRec = new Ext.data.Record({
		  		RowID : "",
				Germ : objItem.GermNme,
				Drug : objItem.AntiName,
				Sen : objItem.IsSen,
				GermObj : null,
				DrugObj : null,
				SetObj  : null,
				HISLab : true
			});
			obj.gridSenTest.getStore().add([objRec]);
		}
		
		//Add By LiYang 2009-11-21 Show Mapping
		var arrySen = GetDrugSenTestMapping("MethodGetDrugSen", LabTestRow).split(CHR_1);
		obj.DisplayMapping(arrySen);
	}
	
	var objPane =({
        	xtype:'fieldset',
        	frame:true,
		//autoHeight:true,
		//width:700,
		layout:"form",
		buttonAlign:'right',
		items:[
			obj.gridSenTest,
			obj.gridSen,
			{
				layout:'column',
				items:
				[
					{
						columnWidth:.6,
				    		layout: 'form',
						items:
						[
							obj.cboGerm
						]
					},
					{
						columnWidth:.05,
				    		layout: 'form'
					},
					{
						columnWidth:.3,
				    		layout: 'form',											
						items:
						[
							obj.cboSen
						]
					}				
				]
			},
			{
				layout:'column',
				items:
				[
					{
						columnWidth:.6,
				    		layout: 'form',											
						items:
						[
							obj.cboDrug
						]
					}
				]
			}
		],
            	buttons:
            	[{
            		text:strAdd,
            		handler:function()
            		{
            			var objGerm = GetDicComboValue(obj.cboGerm);
            			var objAnti = GetDicComboValue(obj.cboDrug);
            			var objSen = GetDicComboValue(obj.cboSen);
            			if((objGerm == null) || (objAnti == null) || (objGerm == 0) || (objAnti == 0) || (objSen == 0) || (objSen == ""))
            			{
            				Ext.Msg.alert(Notice, PleaseSelectGermDrug);
            				return;	
            			}
            			var strKey = "R" + objGerm.RowID + "-" + objAnti.RowID;
            			if(obj.dicSen.Exists(strKey))
            			{
            				Ext.Msg.alert(Notice, SenInTheList);
            			}
            			else
            			{
	            		    var objRec = null;
	            		    var objSel = obj.gridSen.getSelectionModel();
				    if(objSel.selections.items.length > 0)
				    {
				    	objRec = objSel.selections.items[0];
				    	if(objRec.get("HISLab"))
				    	{
					    	objRec.set("Germ", objGerm.Desc);
					    	objRec.set("Drug", objAnti.Desc);
					    	//objRec.set("Sen", obj.chkSen.getValue() ? "Yes" : "No");
					    	objRec.set("Set", objSen.Desc);
					    	objRec.set("GermObj", null);
					    	objRec.set("GermObj", objGerm);
					    	objRec.set("DrugObj", null);
					    	objRec.set("DrugObj", objAnti);
					    	objRec.set("SenObj", null);
					    	objRec.set("SenObj", objSen);
					    	objRec.set("HISLab", false);
					    	objRec.commit();          				
						obj.dicSen.Add(strKey, objRec);
				    	}else{
		            			objRec = new Ext.data.Record({
						  	RowID : "",
						  	Germ : objGerm.Desc,
						  	Drug : objAnti.Desc,
						  	//Sen : obj.chkSen.getValue() ? "Yes" : "No",
						  	Sen : objSen.Desc,
						  	GermObj : objGerm,
						  	DrugObj : objAnti,
						  	SenObj  : objSen,
						  	HISLab : false
						});				
						obj.gridSen.getStore().add([objRec]);            				
            					obj.dicSen.Add(strKey, objRec);					    		
				    	}
				    }else{
					objRec = new Ext.data.Record({
					  	RowID : "",
					  	Germ : objGerm.Desc,
					  	Drug : objAnti.Desc,
					  	//Sen : obj.chkSen.getValue() ? "Yes" : "No",
					  	Sen : objSen.Desc,
					  	GermObj : objGerm,
					  	DrugObj : objAnti,
					  	SenObj  : objSen,
					  	HISLab : false
					});
					obj.gridSen.getStore().add([objRec]);            				
					obj.dicSen.Add(strKey, objRec);	
				    } 
            			}
            		}
            	},
            	{
            		text:strDel,
            		handler:function()
            		{
            			var objSel = obj.gridSen.getSelectionModel();
				var objData = null;
				if(objSel.selections.items.length > 0)
				{
					objData = objSel.selections.items[0];
					if(objData.get("HISLab"))
						return;
					var strKey ="R" + objData.get("GermObj").RowID + "-" + objData.get("DrugObj").RowID;
					obj.dicSen.Remove(strKey);
					obj.gridSen.getStore().remove(objData);
				}
            		}
            	}]
	});
	obj.Win = new Ext.Window({
	        title:GermSenTitle,
                //layout:'form',
                width:710,
                height:480,
                closeAction:'hide',
                plain: true,
                //autoHeight: true,
	        //renderTo:"MainPanel",
	        modal:true,
	        items:[
			new Ext.FormPanel(objPane)
	        ],
	        buttons:[
	        	{
		        	text:strOK,
		        	handler:function()
		        	{
		        	    	var arry = obj.dicSen.Items().toArray();
		        	    	var objRec = null;
		        	    	var dic = new ActiveXObject("Scripting.Dictionary");
		        	    	var objGerm = null;
		        	    	var objDrug = null;
		        	    	var objRecGerm = null;
		        	    	var objRecDrug = null;
		        	    	for(var i = 0; i < arry.length; i ++)
		        	    	{
		        	    		objRec = arry[i];
		        	    		objGerm = objRec.get('GermObj');
		        	    		objDrug = objRec.get('DrugObj');
		        	    		objSen = objRec.get('SenObj');
		        	    		if(!dic.Exists(objGerm.RowID))
		        	    			dic.Add(objGerm.RowID, new DHCMedInfPyObj());
		        	    		objRecGerm = dic.Item(objGerm.RowID);
		        	    		objRecGerm.GermObj = objGerm;
		        	    		objRecGerm.Object = objGerm.RowID;
		        	    		//objRecGerm.Flag = (objDrug.Code == "1" ? "Y" : "N");
		        	    		if (objRecGerm.Flag==""){
		        	    			objRecGerm.Flag=objSen.Code;
		        	    		}else if (objSen.Code=="Y") {
		        	    			objRecGerm.Flag="Y";
		        	    		}else if ((objSen.Code=="N")&&(objRecGerm.Flag!="Y")) {
		        	    			objRecGerm.Flag="N";
		        	    		}else{
		        	    			objRecGerm.Flag="C";
		        	    		}
		        	    		objRecDrug = new DHCMedInfPyObjDrug();
		        	    		objRecDrug.Drug_DR = objDrug.RowID;
		        	    		//objRecDrug.Flag = (objRec.get('Sen') == "Yes" ? "Y" : "N");
		        	    		objRecDrug.Flag = objSen.Code;
		        	    		objRecGerm.arryDrug.push(objRecDrug);
		        	    	}
		        	    	objRepControl.LabGermArry = dic.Items().toArray();
		        	    	obj.Win.hide();
				}
	        	},
	        	{
	        		text:Cancel,
	        		handler:function(){obj.Win.hide();} 
	        	}
	        ]
	}); 
      
	obj.DisplayGerm = function(arry)
	{
  		 var objRec = null;
  		 var objGerm = null;
  		 var objDrug = null;
  		 var objGermDic = null;
  		 var objDrugDic = null;
  		 var strKey = "";
  		 for(var i = 0; i < arry.length ; i ++)
  		 {
	 		objGerm = arry[i];
	 		for(var j = 0; j < objGerm.arryDrug.length; j ++)
	 		{
	 			objDrug = objGerm.arryDrug[j];
	 			objGermDic = GetDicValueFromCombo(obj.cboGerm, 'RowID', objGerm.Object);
	 			objDrugDic = GetDicValueFromCombo(obj.cboDrug, 'RowID', objDrug.Drug_DR);
	 			objSenDic = GetDicValueFromCombo(obj.cboSen, 'Code', objDrug.Flag);
	 			strKey = "R" + objGermDic.RowID + "-" + objDrugDic.RowID;
	 			if(!obj.dicSen.Exists(strKey))
	 			{
  		 			objRec = new Ext.data.Record({
					  	RowID : "",
					  	Germ : objGermDic.Desc,
					  	Drug : objDrugDic.Desc,
					  	//Sen : objDrug.Flag == "Y" ? "Yes" : "No",
					  	Sen : objSenDic.Desc,
					  	GermObj : objGermDic,
					  	DrugObj : objDrugDic,
					  	SenObj : objSenDic,
					  	HISLab : false
					});
					obj.gridSen.getStore().add([objRec]);
					obj.dicSen.Add(strKey, objRec);
          			}
	 		}	
  		 }
	}
	obj.AddAntiByPyHandler = function(tmpObjGerm,tmpObjAnti,tmpObjSen)
	{
	  	var objRec=null;
	  	var strKey = "R" + tmpObjGerm.RowID + "-" + tmpObjAnti.RowID;
	  	if(obj.dicSen.Exists(strKey))
	  	  return;
	  	objRec = new Ext.data.Record({
			RowID : "",
			Germ : tmpObjGerm.Desc,
			Drug : tmpObjAnti.Desc,
			//Sen : tmpchkSen ? "Yes" : "No",
			Sen : tmpObjSen.Desc,
			GermObj : tmpObjGerm,
			DrugObj : tmpObjAnti,
			SenObj  : tmpObjSen,
			HISLab : false
		});
		obj.gridSen.getStore().add([objRec]);
		obj.dicSen.Add(strKey, objRec);
	}
	/* 20100106 ZF
	obj.gridSen.on('click',
	  	function()
	  	{
	  		var objData = GetGridSelectedData(this);
		        if(objData != null)
		        	obj.chkSen.setValue(objData.get("Sen").indexOf(strSen) >= 0);
	  	}
	) 
	*/
	if(objArry != null)
	  	obj.DisplayGerm(objArry);
		return obj;
}

/*
//arryGerm:use to create query result
//cboGerm:when user select a germ from table, this combobox will be selected automatically.
function SelectGermWin(arryGerm, cboGerm) {
    var obj = new Object();
    obj.txtDesc = new Ext.form.TextField({ fieldLabel: Germ, readOnly: false, width: 250 });
    obj.gridGerm = new Ext.grid.GridPanel({
        store: new Ext.data.SimpleStore({
            fields: [
				   { name: 'RowID' },
				   { name: 'Code' },
				   { name: 'Desc' }
				]
        }),
        columns: [
				new Ext.grid.RowNumberer(),
				{ id: 'RowID', header: Code, width: 75, sortable: false, dataIndex: 'Code' },
				{ header: Desc, width: 150, sortable: false, dataIndex: 'Desc' }
	        ],
        stripeRows: true,
        height: 110,
        width: 780
    });

    obj.GermWin = new Ext.Window({
        title: GermName,
        layout: 'form',
        bodyStyle: 'padding:5px;',
        maximizable: false,
        closable: false,
        //collapsible:true,
        shadow: true,
        modal: true,
        width: 500,
        Height: 300,
        plain: true,
        //autoHeight: true,
        //renderTo:"MainPanel",
        //modal:true,
        items: [
            obj.txtDesc,
            obj.gridGerm
        ],
        buttons: [
	        	{
	        	    text: strOK,
	        	    handler: function() {
	        	        Ext.Msg.prompt(
						strDel,
						PleaseInputDelReason,
						function(btn, text) {
						    if (btn == 'ok') {
						        if (text != "") {
						            Ext.Msg.alert("AAAAAAA", PleaseInputDelReason);
						        } else {
						            Ext.Msg.alert(Notice, PleaseInputDelReason);
						        }
						    }
						},
						null,
						true
					    );
	        	    }
	        	},
	        	{
	        	    text: Cancel,
	        	    handler: function() {
	        	        obj.SelectGermWin.close();
	        	    }
	        	}
		]
    });

    return obj;
}


*/