(function(){
	Ext.ns("dhcwl.schema.modify");
})();
dhcwl.schema.modify=function(parentObj){
	var winOfThis=this;
	var curSelNode=null;
	var treeNodeID=null;
	var pObj=parentObj;
	var sourceTabName=null;
	var dsAttrib=null;
	var serviceUrl="dhcwl/schema/schemamodify.csp?";
	var arySelFields=new Array();	//保持已经选择的字段（不是已保存的），用于表达式取值中。
	var editingName=null;
	
	//下面2行不要删，用于给出错误提示
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	
	var comboSchemaType=	new Ext.form.ComboBox({       
			name:'type',
			fieldLabel: '类型',
			allowBlank:false,
			//width:150,
			mode:           'local',
			triggerAction:  'all',
			forceSelection: true,
			editable:       false,
			displayField:   'name',
			valueField:     'value',
			store:          new Ext.data.JsonStore({
				fields : ['name', 'value'],
				data   : [
					{name : '口径',   value: '口径'},
					{name : '度量',  value: '度量'}				
					]
			})			
		});		

	var comboDatatype=	new Ext.form.ComboBox({       
			allowBlank:false,
			name:'dataType',
			fieldLabel: '数据类型',
			//width:150,
			mode:           'local',
			triggerAction:  'all',
			forceSelection: true,
			editable:       false,
			displayField:   'name',
			valueField:     'value',
			store:          new Ext.data.JsonStore({
				fields : ['name', 'value'],
				data   : [
					{name : 'INT',   value: 'INT'},
					{name : 'LONG',  value: 'LONG'},
					{name : 'DATE',   value: 'DATE'},
					{name : 'DOUBLE',  value: 'DOUBLE'},
					{name : 'STRING',   value: 'STRING'}					
					]
			})			
		});		
	var modifyForm= new Ext.FormPanel({
        labelWidth: 75, // label settings here cascade unless overridden
        frame:true,
        title: '数据项修改',
        bodyStyle:'padding:5px 5px 0',
        width: 350,
        defaults: {width: 230},
        defaultType: 'textfield',
        items: [
			{
                fieldLabel: 'ID',
				id:'ID',
                name: 'ID',
                disabled:true
            },{
                fieldLabel: '名称',
				id:'name',
                name: 'name',
				disabled:true
            },{
                fieldLabel: '描述',
                name: 'descript'
            },comboSchemaType
			 ,comboDatatype
			,{
				/*
                fieldLabel: '表达式取值',
                name: 'expVal'
				*/
				xtype: 'compositefield',
                fieldLabel: '表达式取值',
                msgTarget : 'side',
                items: [
                    {
                        name : 'expVal',
						id : 'expVal',
						xtype:'textfield',
						flex: 9
                    },
                    {
						name:'btnExpVal',
						xtype:'button',
						handler:OnShowExpVal,
						flex:1
                    }
                ]				
            },{
				xtype: 'compositefield',
                fieldLabel: '源表字段',
                msgTarget : 'side',
                items: [
                    {
                        name : 'sourceField',
						id : 'sourceField',
						xtype:'textfield',
						flex: 9
                    },
                    {
						name:'btnSourceField',
						xtype:'button',
						handler:OnShowSourceF,
						flex:1
                    }
                ]				
            }
        ],

        buttons: [{
            text: '确定',
			handler:OnConfirm
        },{
			text: '取消',
            handler: OnCancel
        }]
    });
	
	
	
    var modifyWin =new Ext.Window({
        width:380,
		height:400,
		resizable:false,
		closeAction:'close',
		modal:true,
		id:'modifyWin',
    	//title:'报表配置',
    	layout:"fit",
        items: modifyForm
    });	

	function OnConfirm(){
		comboDatatype.enable();
		var FieldValues=modifyForm.getForm().getValues();
		
		var itemName=FieldValues['name'];
				
		var pattern=/[^a-zA-Z_0-9-]/;
		if(pattern.test(itemName)) 
		{
			Ext.Msg.alert("提示","名称只能由 '字母'、'数字'、'-'或'_' 组成!");
			return ;
		}

		if(!modifyForm.getForm().isValid())
		{
			Ext.MessageBox.show({
			   title: '提示',
			   msg: "请检查填写的数据是否正确！",
			   buttons: Ext.MessageBox.OK,
			   icon: Ext.MessageBox.ERROR
		   });
		   return;
		}

		
		var id=Ext.getCmp('ID').getValue();
		var strAction="updateItem";
		if(id=="") {	//在新增页面调用的修改，所以数据项没有ID.
			pObj.updateItem(modifyForm.getForm().getValues()); 
			modifyWin.close();
		}else{
			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
			{
				action:strAction,
				itemID:id,
				//strItemName:FieldValues['name'],
				strItemDesc:FieldValues['descript'],
				strItemType:FieldValues['type'],
				strItemDataType:FieldValues['dataType'],
				strItemLinkedSHMURI:FieldValues['linkedSHMURI'],
				strDirectVal:FieldValues['directVal'],
				strExpVal:FieldValues['expVal'],
				strSourceField:FieldValues['sourceField']
			},
			function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					pObj.reLoadItem(treeNodeID);
					modifyWin.close();
				}else{
					Ext.Msg.alert("操作失败",jsonData.error);
					}
				},this);		
		}

	}
		
	function OnCancel() {
		modifyWin.close();
	}
	function OnShowSourceF(){
		selField=new dhcwl.schema.metaCfg.selField(winOfThis);
		if(treeNodeID) {
			selField.setTreeNodeID(treeNodeID);
			selField.show();
		
		}
		if(dsAttrib) {
			selField.setDsParam(dsAttrib);
			selField.show();
		}
	}
	
	function OnShowExpVal(){
		var calDef=new dhcwl.schema.CalDef(winOfThis);
		if(treeNodeID) {
			calDef.setTreeNodeID(treeNodeID);
		}
		calDef.setSelFields(arySelFields);
		


		if(!editingName) editingName="";
		calDef.initAvailableItem(editingName);
		
		var FieldValues=modifyForm.getForm().getValues();
		var expVal=FieldValues["expVal"];
		calDef.initExp(expVal);
		
		calDef.show();					
	}
	
	modifyWin.on('show',function(th){
		//提示
		Ext.QuickTips.register({
			target: Ext.getCmp("name").el,
			title: '提示',
			text: "名称只能由 '字母'、'数字'、'-'或'_' 组成!"
		});				
		
	});
	
	
	this.setTreeNodeID=function(treeID){
		treeNodeID=treeID;
	}
	
	this.setSourceTabName=function(sourceName){
		sourceTabName=sourceName
	}
	this.InitFormData=function(rec){
		modifyForm.getForm().loadRecord(rec);
		//add by wz.2016-5-230
		if(!rec.get('sourceField')){
			comboDatatype.enable();
			//comboDatatype.setReadOnly(false);
		}else{
			//comboDatatype.setReadOnly(true);
			comboDatatype.disable();
		}		
		
		editingName=rec.get('name');
	}
	
	//在新建数据项中调用
	this.InitFormData2=function(rec){
		modifyForm.getForm().setValues({name:rec.get('itemName')});
		modifyForm.getForm().setValues({descript:rec.get('itemDesc')});
		modifyForm.getForm().setValues({linkedSHMURI:rec.get('linkedSHMURI')});
		modifyForm.getForm().setValues({directVal:rec.get('directVal')});
		modifyForm.getForm().setValues({expVal:rec.get('expVal')});
		modifyForm.getForm().setValues({sourceField:rec.get('sourceField')});
		modifyForm.getForm().setValues({type:rec.get('itemType')});
		modifyForm.getForm().setValues({dataType:rec.get('dataType')});
		
		if(!rec.get('ID')){
			Ext.getCmp("name").enable();
		}
		editingName=rec.get('itemName');
		//modifyForm.getForm().loadRecord(rec);
		
		//add by wz.2016-5-230
		if(!rec.get('sourceField')){
			comboDatatype.enable();
			//comboDatatype.setReadOnly(false);
		}else{
			//comboDatatype.setReadOnly(true);
			comboDatatype.disable();
		}
	}
	this.show=function(){
		modifyWin.show();
	}
	
	this.setLinkedS=function(linkedS){
		modifyForm.getForm().setValues({linkedSHMURI:linkedS});
	}
	
	this.setSourceF=function(sourceF){
		var formValues=modifyForm.getForm().getValues();
		if (formValues['sourceField']!=sourceF.sourceField){
			modifyForm.getForm().setValues({linkedSHMURI:""});
			modifyForm.getForm().setValues({sourceField:sourceF.sourceField});		
			modifyForm.getForm().setValues({expVal:""});
			modifyForm.getForm().setValues({dataType:sourceF.dataType});			
		}
		comboDatatype.disable();
	}
	
	this.setCalF=function(calF){
		var formValues=modifyForm.getForm().getValues();
		if (formValues['expVal']!=calF){
			modifyForm.getForm().setValues({linkedSHMURI:""});
			modifyForm.getForm().setValues({sourceField:""});
			modifyForm.getForm().setValues({expVal:calF});	
			modifyForm.getForm().setValues({dataType:""});			
		}
		comboDatatype.enable();
	}	
	
	this.setDsParam=function(dsParam) {
		dsAttrib=dsParam;
	}
	
	this.setSelFields=function(inSelFields)
	{
		arySelFields=inSelFields
	}
	
	
 };
