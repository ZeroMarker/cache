editFun=function(itemGrid){
	

	
		//���ֵ
	var itemObj=itemGrid.getSelectionModel().selections.items;
	var itemLen = itemObj.length;
	if(itemLen>1){
		Ext.Msg.show({title:'��ʾ',msg:'���ܶԶ��������޸�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
	}else if(itemLen<1){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��һ�������޸�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
	}else{
		
		//��ֵ
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
			//===========����========
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
	fieldLabel: '����',
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
	emptyText : '��ѡ�����',
	name: 'LocResultdetailcheckDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	valueNotFoundText:checkName,
	selectOnFocus:true,
    editable:true
		});
	///======================����============
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
	fieldLabel: '�����Ŀ',
	width:240,
	listWidth : 240,
	resizable:true,
	//allowBlank: true,
	store:SchemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����ں�...',
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


		//����ֵ
		
	var coefficientFiled =new Ext.form.Field({
		fieldLabel:"����ֵ",
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
		fieldLabel:"����ֵ��",
		id:"coefficient2",
		inputType:'text',
		
		width:100	
	});
		//����ֵ��ʽ������
		//����
		var comData = [
			['1','����','='],['2','����','>'],['3','С��','<'],
			['3','���ڵ���','>='],['4','С�ڵ���','<='],['5','����','like'],
			['6','����','between']
		];
		//װ������
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
			fieldLabel: '���ʽ',
			width:240,
			listWidth : 240,
			allowBlank: false,
			store: comStore,
			valueField: 'comCode',
			displayField: 'comDes',
			triggerAction: 'all',
			emptyText:'��ѡ����ʽ...',
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
		
		//���水ť
		var saveBtn = new Ext.Button({
			text:'����',
			//iconCls:'save',
			handler:function(){
				//��ȡֵ
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
							Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							addWin.close();
							CheckCoefficientTabDs.load({params:{start:0, limit:page.pageSize}});
						}else if(jsonData.info=="hasCheck"){
						
						Ext.Msg.show({title:'����',msg:'�ü����Ѿ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						
						}else{
							
							Ext.Msg.show({title:'����',msg:'�޸�ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							
						}
					},
					failure:function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					scope: this
				});
			}
		});
		//ȡ����ť
		var cancleBtn = new Ext.Button({
			text:'ȡ��',
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
						value: '����ֵ��',
						style:{display:' block',width:'75px'}
					},coefficientFiled,betweenAnd,coefficientFiled2]
			}],
			width:350,
			height:200
		});
		
		com.on('select',function(){
				//���ѡ���ֵ
				var selectValue=com.getValue();
				if(selectValue=='between'){
					//���ѡ���Ϊ���䣬��Ҫ�����һ������ֵ�ÿ�
					$("#coefficient").attr("style","width:102px;");
					$("#coefficient2").attr("style","display:block;width:102px;");
					$("#and").attr("style","display:block;");
				}else{
					$("#coefficient").attr("style","width:240px;");
					$("#coefficient2").attr("style","display:none;");
					$("#and").attr("style","display:none;");
					
				}
			});
		//��������
		var addWin = new Ext.Window({
			title:"�޸�����ֵ",
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