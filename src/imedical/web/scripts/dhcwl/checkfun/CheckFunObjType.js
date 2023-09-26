(function(){
Ext.ns("dhcwl.checkfun.CheckFunObjType");
})();
dhcwl.checkfun.CheckFunObjType=function(){
	var serviceUrl="dhcwl/checkfun/checkfunservice.csp";
	var objType="";
	var objCode="";
	var dimValueIds="";
	var parentWin=null;
	var initGrids=0;
	
	var fromColumnModel=new Ext.grid.ColumnModel([
		{header:'ID',dataIndex:'dimCode',sortable:true,width:100,sortable:true,menuDisabled:true
		},{header:'描述',dataIndex:'dimDesc',sortable:true,width:180,sortable:true,menuDisabled:true}
	]);
	var toColumnModel=new Ext.grid.ColumnModel([
		{header:'ID',dataIndex:'dimCode',sortable:true,width:100,sortable:true,menuDisabled:true
		},{header:'描述',dataIndex:'dimDesc',sortable:true,width:180,sortable:true,menuDisabled:true}
	]);
	var fromStore=new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=selDimPro&objType='+objType}),  ///objType basic dim
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
			{name:'dimCode'},
			{name:'dimDesc'}
			]
		}),
		listeners:{
			'load':function(th,recordsoptions){
				if(initGrids==0) return;
				initGrids=0;
				var objTypeForm=parentWin.getForm();
				var dimPro=objTypeForm.getForm().findField('CheckSetDimId').getValue();     
				var aryDimPro=dimPro.split(";");  		
				for (i=0;i<=aryDimPro.length-1;i++){
					var recCnt=fromGrid.getStore().getCount();
					for(j=recCnt-1;j>=0;j--){
					var rec=fromGrid.getStore().getAt(j);
					var dimDesc=rec.get('dimCode');
					if (dimDesc==aryDimPro[i]){
						fromGrid.getStore().remove(rec);
						toGrid.getStore().add(rec);
						}
					}
				}
			}
		}
	});
	var toStore=new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=selObjPro&objCode='+objCode+'&start=0&limit=21&onePage=1'}),
		reader: new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'dimCode'
				},{name:'dimDesc'}
			]
		
		})
	});
	var fromGrid=new Ext.grid.GridPanel({
		height:200,
		width:290,
		store:fromStore,
		cm:fromColumnModel,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{
			}
		}),
		listeners:{
			'rowdblclick':function(th,rowIndex,e){
				var selRec=fromGrid.getStore().getAt(rowIndex);
				var recCnt1=toGrid.getStore().getCount();
				if (recCnt1>=1) {
				alert("每个方案只能有一个维度属性!");
				return;
			}

				fromGrid.getStore().remove(selRec);
				toGrid.getStore().add(selRec);
			}
		}
	});
	var toGrid= new Ext.grid.GridPanel({
		height:200,
		width:290,
		store:toStore,
		cm:fromColumnModel,
		//cm:toColumnModel,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{
			
			}
		}),
		listeners:{
		'rowdblclick':function(th,rowIndex,e){
			var selRec=toGrid.getStore().getAt(rowIndex);
			toGrid.getStore().remove(selRec);
			fromGrid.getStore().add(selRec);
			
			
			}
		}
	});
	var objTypeCbo=new Ext.form.ComboBox({
		fieldLabel : '类型',
		xtype:'combo',
		mode:'remote',
		triggerAction:'all',
		empty:'请选择维度',
		name:'objType',
		id:'objTypeId',
        hiddenName:'objType',
		displayField:'ObjDimDesc',
		valueField:'ObjDimCode',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/checkfun/checkfunservice.csp?action=getobjTypeCbo'}),
			reader:new Ext.data.ArrayReader({},[{name:'ObjDimCode'},{name:'ObjDimDesc'}])
		}),
		/*
		store: new Ext.data.JsonStore({
		        fields : ['ObjDimCode','ObjDimDesc' ],
		        data   : [
 	    			{ObjDimCode:'CTLOC', ObjDimDesc:'科室'}, 
	    		 	{ObjDimCode:'WARD', ObjDimDesc:'病区'}	            
		        ]
		    }),
		    */
		listeners:{
			'select':function(combo,record,index){
				var ObjDimCode=record.get('ObjDimCode');
				var ObjDimDesc=record.get('ObjDimDesc');
				refreshFrom(ObjDimCode);
				toGrid.getStore().removeAll();
			}
		}
	});
	var typeform=new Ext.FormPanel({
						labelAlign : 'right',
				labelWidth : 60,
		frame:true,
		//height:50,
		bodyStyle:'padding:5px',
		style:{
			"margin-right":Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
		},
		/*
		layout:'table',
		defaultConfig:{width:140},
        layoutConfig: {columns:6},
        items:[
        {
			html:'类型:'
        },objTypeCbo
        ]
		*/
		items:objTypeCbo
	});
	var actform=new Ext.FormPanel({
		width:70,
		height:200,
		layout:{
			type:'vbox',
			padding:'5',
			pack:'center',
			align:'center'
		},
		defaults:{margins:'0 0 5 0'},
		items:[{
			xtype:'button',
			//text:'>',
			id:'moveright',
			icon   : '../images/uiimages/moveright.png',	
			width:30,
			handler:onBtnClick
		},{
			xtype:'button',
			//text:' < ',
			id:'moveleft',
			icon   : '../images/uiimages/moveleft.png',	
			width:30,
			handler:onBtnClick
		},{
			xtype:'button',
			id:'moveup',
			//text:'∧',
			icon   : '../images/uiimages/moveup.png',	
			width:30,
			handler:onBtnClick
		},{
			xtype:'button',
			id:'movedown',
			//text:'∨',
			icon   : '../images/uiimages/movedown.png',	
			width:30,
			handler:onBtnClick
		}
		]
	});
	var dimSelPanel=new Ext.Panel({
		layout:"table",
		layoutConfig:{columns:3},
		items:[fromGrid,actform,toGrid]
	});
	var selDimWin=new Ext.Window({
		id:'selDimWin',
		title:'维度属性配置',
		width:670,
		height:330,
		resizable:false,
		layout:'border',
		modal:true,
		closeAction:'hide',
		items:[{
			region:'north',
			height:80,
			layout:'fit',
			items:typeform
		},{
			region:'center',
			layout:'fit',
			items:dimSelPanel
		}
		],
		buttons:[{
			text: '<span style="line-Height:1">确定</span>',
			icon   : '../images/uiimages/ok.png',
			handler:OnConfirm
		},{
text: '<span style="line-Height:1">取消</span>',
icon   : '../images/uiimages/cancel.png',
			handler:OnCancel
		}],
		listeners:{
			'close':function(){
				//selDimWin.close();
				selDimWin.hide();
			}
		}
		
	});
	function onBtnClick(btn){
		//partCalExp=btn.getText();
		partCalExp=btn.getId();
		
		if(partCalExp=="moveright"){
			var selRec=fromGrid.getSelectionModel().getSelected();
			if(!selRec){
				return;
			}
			var recCnt1=toGrid.getStore().getCount();
			if (recCnt1>=1) {
				alert("每个方案只能有一个维度属性!");
				return;
			}
			fromGrid.getStore().remove(selRec);
			toGrid.getStore().add(selRec);
			
		}else{
			var selRec=toGrid.getSelectionModel().getSelected();
			if(!selRec){
				return;
			}
			if(partCalExp=="moveleft"){
				toGrid.getStore().remove(selRec);
				fromGrid.getStore().add(selRec)
			}else if(partCalExp=="moveup"){
				var selIndex=toGrid.getStore().indexOf(selRec)
				if(selIndex<=0) return;
				toGrid.getStore().remove(selRec);
				toGrid.getStore().insert(selIndex-1,selRec)
				toGrid.getSelectionModel().selectRow(selIndex-1);
			}else if(partCalExp=="movedown"){
				var selIndex=toGrid.getStore().indexOf(selRec)
				var cnt=toGrid.getStore().getCount();
				if(selIndex==cnt-1) return;
				toGrid.getStore().remove(selRec);
				toGrid.getStore().insert(selIndex+1,selRec)
				toGrid.getSelectionModel().selectRow(selIndex+1);
			}
		}
	}
	this.showWin=function(parent){
		parentWin=parent;
		selDimWin.show();
		var objTypeForm=parentWin.getForm();
		var dimValue=objTypeForm.getForm().findField('CheckSetObjType').getValue();
		var objId=objTypeForm.getForm().findField('CheckSetObjId').getValue();
		var dimPro=objTypeForm.getForm().findField('CheckSetObjDim').getValue();
		toGrid.getStore().removeAll();
		typeform.getForm().findField('objType').setRawValue(dimValue);
		 dimValueIds=objId;
		initGrids=1;
		refreshFrom(objId);
		if(dimPro!="") Ext.getCmp('objTypeId').disable()
		else Ext.getCmp('objTypeId').enable();
	}
	function OnConfirm(){
		var count=toGrid.getStore().getCount();
		var dimPro="";
		var dimId="";
		var dimValueId="";
		var dimValue="";
		for(var index=0;index<=count-1;index++){
			rec=toGrid.getStore().getAt(index);
			dimCode=rec.get('dimCode');
			dimDesc=rec.get('dimDesc')
			if(dimPro!="") dimPro=dimPro+";";
			dimPro=dimPro+dimDesc;
			dimId=dimId+dimCode;
		}
		//alert(dimValueIds);
		var dimValueId=typeform.getForm().findField('objType').getValue();
		var dimValue=typeform.getForm().findField('objType').getRawValue();
		if (dimValueId=="") dimValueId=dimValueIds; 
		var objTypeForm=parentWin.getForm();
		objTypeForm.getForm().findField('CheckSetObjType').setValue(dimValue);
		objTypeForm.getForm().findField('CheckSetObjId').setValue(dimValueId);
		objTypeForm.getForm().findField('CheckSetObjDim').setValue(dimPro); 
		objTypeForm.getForm().findField('CheckSetDimId').setValue(dimId); 
		selDimWin.hide();
	}
	function refreshFrom(formItemType){
		fromGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=selDimPro&objType='+formItemType));
		fromGrid.getStore().load();
		fromGrid.show();
	}
	function OnCancel(){
		selDimWin.hide();
	}
}