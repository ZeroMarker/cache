editFun=function(itemGrid){
	

	
		//获得值
	var itemObj=itemGrid.getSelectionModel().selections.items;
	var itemLen = itemObj.length;
	if(itemLen>1){
		Ext.Msg.show({title:'提示',msg:'不能对多条进行修改!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
	}else if(itemLen<1){
		Ext.Msg.show({title:'提示',msg:'请选择一条进行修改!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
	}else{
		
		//赋值
		var itemData=itemObj[0].data;
//		console.log(itemData);
		var schemDr=itemData.schemDr;
		var schemName=itemData.schemName;
		var checkName=itemData.checkName;
		var coeff=itemData.coefficient;
		var formu=itemData.formula;
		var checkDr = itemData.checkDr;
		var formulaCode=itemData.formulaCode
		//==========================formPanel==============//
			//===========检查点========
	var checkDs = new Ext.data.Store({
		
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
	checkDs.on('beforeload', function(ds, o) {
	
		ds.proxy = new Ext.data.HttpProxy({
						url : CheckCoefficientTabUrl+'?action=ListCheck&str='+encodeURIComponent(Ext.getCmp('checkField').getRawValue())+'&schemdr='+Ext.getCmp('SchemeField').getValue(),
					method : 'POST'
				});
				/*
		ds.baseParam={
			str:Ext.getCmp('checkField').getRawValue(),
			schemdr:Ext.getCmp('SchemeField').getValue()
		};
		*/
		});
var checkCom = new Ext.form.ComboBox({
	id: 'checkField',
	fieldLabel: '检查点',
	width:240,
	listWidth : 240,
	resizable:true,
	//allowBlank: false,
	store: checkDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	//typeAhead : true,
	//triggerAction : 'all',
	emptyText : '请选择检查点',
	name: 'LocResultdetailcheckDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	valueNotFoundText:checkName,
	selectOnFocus:true,
    editable:true
		});
	///======================方案============
	var SchemeDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


SchemeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
			url:projUrl+'?action=ListschemDr',
			method:'POST'});
	ds.baseParam={
			str:encodeURIComponent(Ext.getCmp('SchemeField').getRawValue()),
			userid:userid
		};

});

var SchemeField = new Ext.form.ComboBox({
	id: 'SchemeField',
	fieldLabel: '检查项目',
	width:240,
	listWidth : 240,
	resizable:true,
	//allowBlank: true,
	store:SchemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择病例内涵...',
	name: 'SchemeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	valueNotFoundText:schemName,
	forceSelection:'true',
	editable:true
});

SchemeField.on("beforeselect",function(){
		var check=checkCom.getValue();
		
      	if(check!=""){
			checkCom.clearValue();
			
	    }
	});
	
SchemeField.addListener('select',function(){
	checkDs.load({params:{start:0,limit:10}});
});


		//特殊值
		
	var coefficientFiled =new Ext.form.Field({
		fieldLabel:"特殊值",
		id:"coefficient",
		inputType:'text',
		width:240	
	});
	var betweenAnd = new Ext.form.DisplayField({			
			id:'and',
			style:'padding-top:3px;',
			value: '&nbsp;&nbsp;and&nbsp;&nbsp;'
				
		});
	var coefficientFiled2 =new Ext.form.Field({
		fieldLabel:"特殊值：",
		id:"coefficient2",
		inputType:'text',
		
		width:100	
	});
		//特殊值公式下拉框
		//数据
		var comData = [
			['1','等于','='],['2','大于','>'],['3','小于','<'],
			['3','大于等于','>='],['4','小于等于','<='],['5','包含','like'],
			['6','区间','between']
		];
		//装备数据
		var comStore = new Ext.data.Store({
			proxy: new Ext.data.MemoryProxy(comData),
			reader: new Ext.data.ArrayReader({},[
				{name:'comID'},
				{name:'comDes'},
				{name:'comCode'}
			])	
		});
		var com = new Ext.form.ComboBox({
			id: 'comField',
			fieldLabel: '表达式',
			width:240,
			listWidth : 240,
			allowBlank: false,
			store: comStore,
			valueField: 'comCode',
			displayField: 'comDes',
			triggerAction: 'all',
			emptyText:'请选择表达式...',
			name: 'comField',
			minChars: 1,
			valueNotFoundText:formu,
			editable:true,
			
			resizable:true
		}); 
		
		Ext.getCmp('SchemeField').setRawValue(schemName);
		Ext.getCmp('SchemeField').setValue(schemDr);
		Ext.getCmp('checkField').setRawValue(checkName);
		Ext.getCmp('checkField').setValue(checkDr);
		Ext.getCmp('comField').setValue(formulaCode);
		Ext.getCmp('comField').setRawValue(formu);
		
		//保存按钮
		var saveBtn = new Ext.Button({
			text:'保存',
			//iconCls:'save',
			handler:function(){
				//获取值
				var checkDr2 = Ext.getCmp('checkField').getValue();
				//var schemDr = Ext.getCmp('SchemeField').getRawValue();
				var schemDr2 = Ext.getCmp('SchemeField').getValue();
				var com = Ext.getCmp('comField').getValue();
				
				var coefficient = encodeURIComponent(Ext.getCmp('coefficient').getRawValue());
				var rowid=itemData.rowid;
			
				var coefficient2=Ext.getCmp("coefficient2").getValue();
			
				if(coefficient2!=""){
					var data = schemDr2+"^"+checkDr2+"^"+com+"^"+coefficient+"and"+coefficient2+"^"+rowid
				}else{
					var data = schemDr2+"^"+checkDr2+"^"+com+"^"+coefficient+"^"+rowid
				}
				
				Ext.Ajax.request({
					url:CheckCoefficientTabUrl+'?action=edit&dataStr='+data,
					success:function(result,request){
						//console.log(result);
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'提示',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							addWin.close();
							CheckCoefficientTabDs.load({params:{start:0, limit:page.pageSize}});
						}else if(jsonData.info=="hasCheck"){
						
						Ext.Msg.show({title:'错误',msg:'该检查点已经添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						
						}else{
							
							Ext.Msg.show({title:'错误',msg:'修改失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							
						}
					},
					failure:function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					scope: this
				});
			}
		});
		//取消按钮
		var cancleBtn = new Ext.Button({
			text:'取消',
			//iconCls:'',
			handler:function(){
				addWin.close();
			}
		});
		var formPanel=new Ext.form.FormPanel({
			frame:true,
			bodyStyle:'padding:5px 5px 0',
			labelWidth:70,
			//baseCls : 'x-plain',
			items:[{
				layout:'form',
				items:[SchemeField,checkCom,com]
			},{
				layout:'column',
				items:[{
						xtype:'displayfield',
						value: '特殊值：',
						style:{display:' block',width:'75px'}
					},coefficientFiled,betweenAnd,coefficientFiled2]
			}],
			width:350,
			height:200
		});
		
		com.on('select',function(){
				//获得选择的值
				var selectValue=com.getValue();
				if(selectValue=='between'){
					//如果选择的为区间，则要再添加一个特殊值得框
					$("#coefficient").attr("style","width:102px;");
					$("#coefficient2").attr("style","display:block;width:102px;");
					$("#and").attr("style","display:block;");
				}else{
					$("#coefficient").attr("style","width:240px;");
					$("#coefficient2").attr("style","display:none;");
					$("#and").attr("style","display:none;");
					
				}
			});
		//弹出窗体
		var addWin = new Ext.Window({
			title:"修改特殊值",
			height:250,
			width:350,
			//plain : true,
			modal : true,
			//bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items:[formPanel],
			buttons: [saveBtn,cancleBtn]
		});
		
		addWin.on('afterrender',function(){
			if(coeff.indexOf("~")>0){
				Ext.getCmp('coefficient').setValue(trim(coeff.split("~")[0]));
				Ext.getCmp('coefficient2').setValue(trim(coeff.split("~")[1]));
				$("#coefficient").attr("style","width:102px;");
				$("#coefficient2").attr("style","display:block;width:102px;");
				//$("#and").attr("style","display:block;");
			}else{
				Ext.getCmp('coefficient').setValue(coeff);
				$("#coefficient2").attr("style","display:none;");
				$("#and").attr("style","display:none;");
				
			}
		});
		addWin.show();
	}
	
	
	
}