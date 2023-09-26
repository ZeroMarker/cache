function frmSelectDoctor(objParent, evhandler)
{
	var obj = new Object();
	obj.txtCode = new Ext.form.TextField({fieldLabel:DoctorCode});
	obj.txtName = new Ext.form.TextField({fieldLabel:DoctorName});
	var fn = function()
	{
		var strCode = this.txtCode.getValue();
		var strName = this.txtName.getValue();
		var strCtloc = "";
		if((strCode == "") && (strName == ""))
			return;
		var objArry = QueryDoctorList("MethodQueryDoctor", strCode, strName, strCtloc);
		var objRec = null;
		var obj = null;
		var objStore = this.gridDoctor.getStore();
		objStore.removeAll();
		for(var i = 0; i < objArry.length ; i ++)
		{
				obj = objArry[i];
				objRec = new Ext.data.Record(
						{
							RowID:obj.RowID,
					    Code:obj.Code,
					    DoctorName:obj.DoctorName,
					    Department:obj.Department.DepName,
					    DicObj:obj
					  }
				)
				objStore.add([objRec]);
				
		}		
	}
	
	
	obj.txtCode.on("specialkey", fn, obj);
	obj.txtName.on("specialkey", fn, obj);
	
	obj.gridDoctor = new Ext.grid.GridPanel({
        store: new Ext.data.SimpleStore({
			fields: [
			   {name: 'RowID'},
			   {name: 'Code'},
			   {name: 'DoctorName'},
			   {name: 'Department'},
			   {name: 'DicObj'}
			]
		}),
        columns: [
						new Ext.grid.RowNumberer(),
            {id:'RowID', header: DoctorCode, width: 75, sortable: false, dataIndex: 'Code'},
            {header: DoctorName, width: 100, sortable: false, dataIndex: 'DoctorName'},
            {header: Department, width: 100, sortable: false, dataIndex: 'Department'}
        ],
        stripeRows: true,
        height:150,
        width:380
    }); 
   var objPane =(
   		{
            xtype:'fieldset',
            frame:true,
                        //autoHeight:true,
						width:400,
						layout:"form",
            //renderTo:"BasePanel",
						items:[
							   obj.txtCode,
							   obj.txtName,
  							 obj.gridDoctor
                  ]
   		});
   obj.Win = new Ext.Window({
        title:DoctorQueryTitle,
                //layout:'form',
                width:430,
                height:300,
                closeAction:'hide',
                plain: true,
                //autoHeight: true,
        //renderTo:"MainPanel",
        modal:true,
        items:
        		[            
							new Ext.FormPanel(objPane)
            ],
        buttons:[
        	{
        	    text:strOK,
        	    handler:function()
        	    {
        	    	var objData = GetGridSelectedData(obj.gridDoctor);
        	    	if(objData != null)
        	    	{
        	    		if(evhandler != null)
        	    		{
        	    			evhandler.call(objParent, objData);
        	    			obj.Win.hide();
        	    		}
        	    	}
        	    	else
        	    	{
        	    		Ext.Msg.alert(Notice, PleaseChooseItem);
        	    	}
				  		}  
        	},
        	{
        	    text:Cancel,
        	    handler:function(){obj.Win.hide();} 
        	}
        	]
      }); 
	return obj;
}
/*
function txtPinyin_OnChange()
{
	var strCode = this.txtCode.getValue();
	var strName = this.txtName.getValue();
	var strCtloc = "";
	if((strCode == "") && (strName == ""))
		return;
	var objArry = QueryDoctorList("MethodQueryDoctor", strCode, strName, strCtloc);
	var objRec = null;
	var obj = null;
	var objStore = this.gridDoctor.getStore();
	objStore.removeAll();
	for(var i = 0; i < objArry.length ; i ++)
	{
			obj = objArry[i];
			objRec = new Ext.data.Record(
					{
						RowID:obj.RowID,
				    Code:obj.Code,
				    DoctorName:obj.DoctorName,
				    Department:obj.Department.DepName,
				    DicObj:obj
				  }
			)
			objStore.add([objRec]);
			
	}
}*/