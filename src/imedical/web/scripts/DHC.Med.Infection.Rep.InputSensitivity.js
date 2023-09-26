function frmInputSensitivity()
{
	var obj = new Object();
	obj.cboGerm = new Ext.form.ComboBox({fieldLabel:GermName,width:150,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionLabSampleType"),displayField:"Description",valueField:"Code"});
	obj.cboInfPosition = new Ext.form.ComboBox({fieldLabel:Position,editable:false,mode: 'local', triggerAction: 'all',store:CreateInfectionPositionStore(),displayField:"Description",valueField:"Code"});
	obj.cboSen = new Ext.form.ComboBox({fieldLabel:Sen,width:150,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("YesNo"),displayField:"Description",valueField:"Code"});
	obj.gridSen = new Ext.grid.GridPanel({
        store: new Ext.data.SimpleStore({
			fields: [
			   {name: 'RowID'},
				 {name: 'Position'},			 
				 {name: 'Germ'},
				 {name: 'Sen'},
				 {name: 'PositionRowID'},
				 {name: 'GermRowID'},
				 {name: 'Sen'}
			]
		}),
        columns: [
						new Ext.grid.RowNumberer(),
            {id:'RowID', header: Position, width: 200, sortable: false, dataIndex: 'Position'},
            {header: GermName, width: 200, sortable: false, dataIndex: 'Germ'},
            {header: Sen, width: 200, sortable: false, dataIndex: 'Sen'},
        ],
        stripeRows: true,
	        height:250,
	        width:730
	    });
		var objLabPane = (
   		{
   					title:SensitivityInfo,
                        xtype:'fieldset',
                        frame:true,
                        //autoHeight:true,
						width:780,
                        //defaults: {width: 800},
                        //defaultType: 'textfield',
            height:450,
						layout:"form",
            //renderTo:"LabPanel",
            buttonAlign:'right',
						items:[
							   obj.gridSen,
                        		{
                        			layout:'column',
                        			items:[
                        				{
					                      	columnWidth:.3,
									                layout: 'form',
									                items: [obj.cboInfPosition]
					                      },
					                      {
					                      	columnWidth:.3,
									                layout: 'form',
									                items: [obj.cboGerm]
					                      },{
					                      	columnWidth:.3,
									                layout: 'form',
									                items: [obj.cboSen]
					                      }
                        			]	
                        		}
             ],
             buttons:[
             		{
             			text:Del,
             			handler:function()
										{window.alert("Del");}
             		},
             		{
             			text:Save,
             			handler:function()
             				{
             					
             					
             				}
             		}
             		
             ]
                       
   		});	    	  
	return obj;	
}