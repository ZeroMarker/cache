(function(){
	Ext.ns("dhcwl.ds.modify");
})();
//*******************************************************************改js用于自定义数据项使用**********************************************
dhcwl.ds.modify=function(parentObj){
	var winOfThis=this;
	var pObj=parentObj;
	var treeNodeID=null;
	var serviceUrl="dhcwl/schema/schemamodify.csp?";
	var arySelFields=new Array();	//保持已经选择的字段（不是已保存的），用于表达式取值中。
	var editingName=null;
	
	//下面2行不要删，用于给出错误提示
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	
	var comboSchemaType=new Ext.form.ComboBox({       
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
        title: '自定义数据项',
		boader:false,
        bodyStyle:'padding:5px 5px 0',
        width: 350,
		buttonAlign:'center',
        defaults: {width: 230},
        defaultType: 'textfield',
        items: [{
                fieldLabel: '名称',
				id        :'name',
                name      : 'name',
				allowBlank: false
            },{
                fieldLabel: '描述',
                name      : 'descript',
				allowBlank: false
            },comboSchemaType
			 ,comboDatatype,{
				 fieldLabel:'表达式',
				 id        :'expVal',
				 name      :'expVal',
				 allowBlank: false
			 }
        ],

        buttons: [{
            //text: '确定',
			text: '<span style="line-Height:1">确定</span>',
			icon   : '../images/uiimages/ok.png',
			handler:OnConfirm
        },{
			//text: '取消',
			text: '<span style="line-Height:1">取消</span>',
			icon   : '../images/uiimages/cancel.png',
            handler: OnCancel
        }]
    });
	
	
	
    var modifyWin =new Ext.Window({
        width      :380,
		height     :300,
		boader     :false,
		resizable  :false,
		closeAction:'close',
		modal      :true,
		id         :'modifyWin',
    	layout     :"fit",
        items      :modifyForm
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

		pObj.updateItem(modifyForm.getForm().getValues()); 
		modifyWin.close();
	}
		
	function OnCancel() {
		modifyWin.close();
	}
	
	modifyWin.on('show',function(th){
		//提示
		Ext.QuickTips.register({
			target: Ext.getCmp("name").el,
			title: '提示',
			text: "名称只能由 '字母'、'数字'、'-'或'_' 组成!"
		});				
		
	});
	
	this.show=function(){
		modifyWin.show();
	}
	
	
 };
