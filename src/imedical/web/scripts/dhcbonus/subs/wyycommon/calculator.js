//编辑公式
formula = function(scheme,type,formulaTrgg){
	//type=1:表示添加操作
	//type=2:表示修改操作
	if(type==1){
		//用于显示
		globalStr = "";
		//表达式描述
		expreDesc = "";
		//用于退格
		globalStr2 = "";
		//用于存储
		globalStr3 = "";
		checkStr="";
	}
	//if(type==2){
	//	////用于显示
	//	//globalStr = node.attributes.expName;
	//	////表达式描述
	//	//expreDesc = node.attributes.expDesc;
	//	////用于退格
	//	//globalStr2 = node.attributes.expName2;
	//	////用于存储
	//	//globalStr3 = node.attributes.expression;
	//}
	
		
	var area = new Ext.form.TextArea({
		id:'area',
		width:500,
		height:100,
		labelWidth:20,
		fieldLabel: '计算公式',
		readOnly:true
	});
	//area.setValue(globalStr);
	
	//var m = new Ext.form.TextField({
	//	id:'m',
	//	fieldLabel:'友情提示',
	//	allowBlank:true,
	//	width:700,
	//	emptyText:'请先清空表达式再编辑,以保证计算公式的准确性!',
	//	anchor:'90%',
	//	editable:false,
	//	readOnly:true,
	//	disabled:true
	//});
	//var expdesc = new Ext.form.TextField({
	//	id:'expdesc',
	//	fieldLabel:'公式描述',
	//	allowBlank: true,
	//	width:700,
	//	emptyText:'',
	//	anchor:'90%',
	//	selectOnFocus:'true'
	//});
	
	//expdesc.setValue(expreDesc);
	
	var bonusTargetDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','BonusTargetCode','BonusTargetName'])
	});

	bonusTargetDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.base10exe.csp?action=base10list',method:'POST'})
	});


	var bonusTargetComb = new Ext.form.ComboBox({
		fieldLabel:'指标标识',
		width:230,
		allowBlank:true,
		store:bonusTargetDs,
		valueField:'BonusTargetCode',
		displayField:'BonusTargetName',
		triggerAction:'all',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
			
	bonusTargetComb.on("select",function(cmb,rec,id ){
		showValue(cmb.getRawValue(),'^T'+cmb.getValue());
		bonusTargetComb.setValue("");
		//alert(rec.get('rowid'));
		checkStr=checkStr+' '+rec.get('rowid')+' ';
	});
	
	var bonusItemDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','SchemeItemCode','SchemeItemName'])
	});

	bonusItemDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.scheme01exe.csp?action=itemlist&type='+scheme,method:'POST'})
	});
		
	var bonusItemComb = new Ext.form.ComboBox({
		fieldLabel:'奖金项标识',
		width:230,
		allowBlank:true,
		store:bonusItemDs,
		valueField:'SchemeItemCode',
		displayField:'SchemeItemName',
		triggerAction:'all',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
		
	bonusItemComb.on("select",function(cmb,rec,id ){
		showValue(cmb.getRawValue(),'^S'+cmb.getValue());
		bonusItemComb.setValue("");
		checkStr=checkStr+' '+rec.get('rowid')+' ';
	});
		
	var form = new Ext.form.FormPanel({
		//title: '公式编辑区域',
		listWidth:10,
		frame:true,
		bodyStyle:'padding:5 5 5 5',
		region:'north',
		height:185,
		labelSeparator:':',
		width:510,
		items:[area,/*expdesc,m,*/bonusTargetComb,bonusItemComb]
	});

	function showValue(name,code){
		globalStr=globalStr+name;
		if(globalStr2==""){
			globalStr2=code;
		}else{
			globalStr2=globalStr2+code;
		}
		area.setValue(globalStr);
	};

	var autohisoutmedvouchForm = new Ext.form.FormPanel({
		listWidth:20,
		//title: '公式编辑符号',
		region:'center',
		frame:true,
		height:25,
		bodyStyle:'padding:5 5 5 5',
		labelSeparator:':',
		width:550,
		items:[{
			xtype:'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
				{
					columnWidth:.05,
					xtype:'button',
					text: '9',
					tooltip:'9', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+rec.get('rowid');
						checkStr=checkStr+this.text;
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '8',
					tooltip:'8', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+this.text;
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '7',
					tooltip:'7', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+this.text;
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '6',
					tooltip:'6', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+this.text;
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '5',
					tooltip:'5', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+this.text;
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '4',
					tooltip:'4', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+this.text;
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '3',
					tooltip:'3', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+this.text;
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '2',
					tooltip:'2', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+this.text;
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '1',
					tooltip:'1', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+this.text;
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '0',
					tooltip:'0', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+this.text;
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '.',
					tooltip:'点', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+this.text;
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '{',
					tooltip:'左大括弧', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+this.text+' ';
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '}',
					tooltip:'右大括弧', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+this.text+' ';
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '[',
					tooltip:'左中括弧', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+this.text+' ';
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: ']',
					tooltip:'右中括弧', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+this.text+' ';
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '(',
					tooltip:'左小括弧', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+this.text+' ';
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: ')',
					tooltip:'右小括弧', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+this.text+' ';
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '+',
					tooltip:'加号', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+'a'+' ';
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '-',
					tooltip:'减号', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+this.text+' ';
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '*',
					tooltip:'乘号', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+this.text+' ';
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '/',
					tooltip:'除号', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+this.text+' ';
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},{
					columnWidth:.05,
					xtype:'button',
					text: '^',
					tooltip:'指数', 
					handler:function(b){
						globalStr=globalStr+this.text;
						globalStr2=globalStr2+"^"+this.text;
						checkStr=checkStr+' '+this.text+' ';
						area.setValue(globalStr);
					}
				},{
					columnWidth:.035,
					xtype:'displayfield'
				},
				/*{
					columnWidth:.05,
					xtype:'button',
					text: '<-',
					tooltip:'回退', 
					handler:function(b){
						var arr = globalStr2.split("^");
						var substr=arr[arr.length-1]; //05月!5
						alert(substr);
						var sublength=substr.length; //6
						//var substrarr=substr.split("!"); 
						//var subsubstr=substrarr[0]; //05月
						//var subsublength=subsubstr.length; //3
						globalStr=globalStr.substring(0,globalStr.length-sublength);
						area.setValue(globalStr);
						//globalStr2=globalStr2.substring(0,globalStr2.length-sublength-"^".length);
					}
				},
				{
					columnWidth:.035,
					xtype:'displayfield'
				},*/{
					columnWidth:.135,
					xtype:'button',
					text: 'C',
					tooltip:'清空', 
					handler:function(b){
						globalStr="";
						globalStr2="";
						checkStr="";
						area.setValue(globalStr);
					}
				}
			]
		}]
	});
		
	var OkButton = new Ext.Toolbar.Button({
		text:'确定',
		handler:function(){
				
			//var uploadUrl = "http://localhost:8080/dhcba/formulaverify";
			///////////////////////var exp = encodeURIComponent(Ext.encode(exp));
			var upUrl = dhcbaUrl+"/dhcba/formulaverify?exp="+checkStr;
			Ext.Ajax.request({
				//alert(upUrl);
				//autohisoutmedvouchForm.getForm().submit({
				//method : 'POST',
				url:upUrl,
				waitMsg:'验证中...',
				failure: function(result, request){
					//alert('tmpFal');
					//alert(result.responseText);
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
				},
				success: function(result, request){
					//alert('tmpsucc');
					var jsonData = Ext.util.JSON.decode(result.responseText);
					//alert(result.responseText);
					if(jsonData.info=="success"){
						//return globalStr;
						//m.setValue("表达式正确，可以保存！");
						//var handler = function(){
						//	expreField.setValue(globalStr); //控件显示
						//	expreDescField.setValue(expdesc.getValue()); //描述控件显示
						//	win.close();
						//}
						//Ext.Msg.show({title:'提示',msg:'表达式正确!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					formulaTrgg.setValue(globalStr);
					formu=globalStr2;
					win.close();
					}if(jsonData.info=="failure"){
						Ext.Msg.show({title:'提示',msg:'计算操作符错误,请检查!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
						//m.setValue("计算操作符错误,请检查！");
						//globalStr3="";
						//return false;
					}if(jsonData.info=="other"){
						Ext.Msg.show({title:'提示',msg:'表达式错误,请检查！',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
						//m.setValue("表达式错误,请检查！");
						//globalStr3="";
						//return false;
					}
				},
				scope: this
			});		
		}
	});

	var cancelButton = new Ext.Toolbar.Button({
		text:'取消'
	});
	
	//定义取消修改按钮的响应函数
	cancelHandler = function(){
		win.close();
	}
	
	//添加取消按钮的监听事件
	cancelButton.addListener('click',cancelHandler,false);
		
	win = new Ext.Window({
		title: '公式设计器',
		width: 715,
		height:320,
		minWidth: 715, 
		minHeight: 320,
		layout:'border',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:[form,autohisoutmedvouchForm],
		buttons:[
			OkButton,
			cancelButton
		]
	});
	//窗口显示
	win.show();
}