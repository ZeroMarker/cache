
//沟通记录frame
function InComRecSubScreen(){
	
	var obj = new Object();
	
	
	//$$$$$$$$$$$$$$$$$$$$$$$$$$$
	obj.ComDate = new Ext.form.DateField({
		id : 'ComDate'
		,format : 'Y-m-d'
		//,width : 100
		//,columnWidth : .3
		,fieldLabel : '沟通日期'
		,anchor : '100%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		//,value : new Date()
	});
	
	obj.winDComDate = new Ext.Panel({
		id : 'winDComDate'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ComDate
		]
	});
	
	obj.ComTime = new Ext.form.TimeField({
		id : 'ComTime'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '沟通时间'
		//,renderTo: Ext.get('times') 
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,invalidText:'请选择时间或输入有效格式的时间'
		,regexText:'时间格式错误，正确格式hh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	
	obj.winDComTime = new Ext.Panel({
		id : 'winDComTime'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ComTime
		]
	});
	
	
	obj.winFPanel3 = new Ext.form.FormPanel({
		id : 'winFPanel3'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winDComDate
			,obj.winDComTime
			
		]
	});
	
	obj.txtComDuration = new Ext.form.TextField({
		id : 'txtComDuration'
		,fieldLabel : '沟通时长'
		,columnWidth : .5
		,anchor : '100%'
});

obj.winComDuration = new Ext.Panel({
		id : 'winComDuration'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.txtComDuration
		]
	}); 

obj.cmbComWay = Common_ComboToDic("cmbComWay","沟通方式","Communication");	//Communication
obj.winComWay = new Ext.Panel({
		id : 'winComWay'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.cmbComWay
		]
	});

	obj.winFPanel4 = new Ext.form.FormPanel({
		id : 'winFPanel4'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winComDuration
			,obj.winComWay
			
		]
	});
	
	obj.cboHosUser = Common_ComboUser("cboHosUser","院方与会人","");
	obj.cboProUser = Common_ComboDemHandler("cboProUser","公司与会人","");
	obj.txtHosStr = new Ext.form.TextField({
		id : 'txtHosStr'
		,fieldLabel : '院方与会人'
		//,columnWidth : .6
		,anchor : '100%'
});


obj.winHosStr = new Ext.Panel({
		id : 'winHosStr'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		//,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.txtHosStr
		]
	}); 
		obj.txtPrjStr = new Ext.form.TextField({
		id : 'txtPrjStr'
		,fieldLabel : '公司与会人'
		//,columnWidth : .6
		,anchor : '100%'
});
	obj.winPrjStr = new Ext.Panel({
		id : 'winPrjStr'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.txtPrjStr
		]
	});
	
	obj.txtOtherStr = new Ext.form.TextField({
		id : 'txtOtherStr'
		,fieldLabel : '其他与会者'
		//,columnWidth : .6
		,anchor : '100%'
});
	obj.winOtherStr = new Ext.Panel({
		id : 'winOtherStr'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.txtOtherStr
		]
	});
	
		obj.txtLocation = new Ext.form.TextField({
		id : 'txtLocation'
		,fieldLabel : '地点'
		//,columnWidth : .6
		,anchor : '100%'
		});
		
		obj.winLocation = new Ext.Panel({
		id : 'winLocation'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.txtLocation
		]
	});
	
	obj.winNewFPanel = new Ext.Panel({
		id : 'winNewFPanel'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		//,columnWidth : .5
		,layout : 'column'
		,items:[
			obj.winOtherStr
			,obj.winLocation
		]
	});
	
	
	obj.txtComNote = new Ext.form.TextArea({ //winfPIconClass
		id : 'txtComNote'
		,height : 90
		,fieldLabel : '沟通内容'
		,anchor : '90%'
	});
	
	obj.winComNote = new Ext.Panel({
		id : 'winComNote'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.txtComNote
		]
	});
	
	obj.btnSubmit = new Ext.Button({
		id : 'btnSubmit'
		,iconCls : 'icon-add'
		//,columnWidth : .15
		,text : '提交'
	});
	
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-cancel'
		//,columnWidth : .15
		,text : '取消'
	});
	
	obj.winSubmit = new Ext.Panel({
		id : 'winSubmit'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .2
		//,layout : 'form'
		,items:[obj.btnSubmit]
		
	});
	obj.winCancel = new Ext.Panel({
		id : 'winCancel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .2
		//,layout : 'form'
		,items:[obj.btnCancel]
		
	});
	obj.winblank1 = new Ext.Panel({
		id : 'winblank1'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .4
		
		
	});
	
	
	obj.winblank2 = new Ext.Panel({
		id : 'winblank2'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .4
		
		
	});
	obj.winFPanel5 = new Ext.form.FormPanel({
		id : 'winFPanel5'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winblank1
			,obj.winSubmit
			,obj.winCancel
			,obj.winblank2
			
			
		]
	});
	
	obj.DemandID = new Ext.form.TextField({
		id : 'DemandID'
		,hidden : true
});	

obj.HandlePanal1=new Ext.Panel({
			id : 'HandlePanal1'
			//,title:'沟通记录'
			,layout : 'form'
			,style:{border:'3px solid'}
			//,autoScroll : true
			//,animCollapse: true
			//,columnWidth: 0.4
			,region:'center'
			,frame:true
			//,width : 300
			//,collapsible: true
			,items:[
			/* obj.winDemName
			,obj.winFPanel1
			,obj.winFPanel2
			,obj.winHandRecPanel */
			obj.winFPanel3
			,obj.winFPanel4
			,obj.winHosStr
			,obj.winPrjStr
			//,obj.winOtherStr
			,obj.winNewFPanel
			,obj.winComNote
			,obj.winFPanel5
			,obj.DemandID
			
			
			
		]
			
		});

//$$$$$$$$$$$$$$$$$$$$$$$$$$$
		
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 350
		//,buttonAlign : 'form'
		,width : 500
		,modal : true
		,title : '沟通记录'
		,layout : 'border'
		,border:true
		,frame:true
		,items:[
			obj.HandlePanal1
			//obj.winTPanelUser
			
		
	
		]
		
	});
	
	
	
	InComRecSubScreenEvent(obj);
	
	
	
	//事件处理代码
obj.LoadEvent(arguments);
	
	return obj;
	
}