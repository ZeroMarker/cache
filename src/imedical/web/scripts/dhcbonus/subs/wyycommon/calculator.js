//�༭��ʽ
formula = function(scheme,type,formulaTrgg){
	//type=1:��ʾ��Ӳ���
	//type=2:��ʾ�޸Ĳ���
	if(type==1){
		//������ʾ
		globalStr = "";
		//���ʽ����
		expreDesc = "";
		//�����˸�
		globalStr2 = "";
		//���ڴ洢
		globalStr3 = "";
		checkStr="";
	}
	//if(type==2){
	//	////������ʾ
	//	//globalStr = node.attributes.expName;
	//	////���ʽ����
	//	//expreDesc = node.attributes.expDesc;
	//	////�����˸�
	//	//globalStr2 = node.attributes.expName2;
	//	////���ڴ洢
	//	//globalStr3 = node.attributes.expression;
	//}
	
		
	var area = new Ext.form.TextArea({
		id:'area',
		width:500,
		height:100,
		labelWidth:20,
		fieldLabel: '���㹫ʽ',
		readOnly:true
	});
	//area.setValue(globalStr);
	
	//var m = new Ext.form.TextField({
	//	id:'m',
	//	fieldLabel:'������ʾ',
	//	allowBlank:true,
	//	width:700,
	//	emptyText:'������ձ��ʽ�ٱ༭,�Ա�֤���㹫ʽ��׼ȷ��!',
	//	anchor:'90%',
	//	editable:false,
	//	readOnly:true,
	//	disabled:true
	//});
	//var expdesc = new Ext.form.TextField({
	//	id:'expdesc',
	//	fieldLabel:'��ʽ����',
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
		fieldLabel:'ָ���ʶ',
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
		fieldLabel:'�������ʶ',
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
		//title: '��ʽ�༭����',
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
		//title: '��ʽ�༭����',
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
					tooltip:'��', 
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
					tooltip:'�������', 
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
					tooltip:'�Ҵ�����', 
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
					tooltip:'��������', 
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
					tooltip:'��������', 
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
					tooltip:'��С����', 
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
					tooltip:'��С����', 
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
					tooltip:'�Ӻ�', 
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
					tooltip:'����', 
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
					tooltip:'�˺�', 
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
					tooltip:'����', 
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
					tooltip:'ָ��', 
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
					tooltip:'����', 
					handler:function(b){
						var arr = globalStr2.split("^");
						var substr=arr[arr.length-1]; //05��!5
						alert(substr);
						var sublength=substr.length; //6
						//var substrarr=substr.split("!"); 
						//var subsubstr=substrarr[0]; //05��
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
					tooltip:'���', 
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
		text:'ȷ��',
		handler:function(){
				
			//var uploadUrl = "http://localhost:8080/dhcba/formulaverify";
			///////////////////////var exp = encodeURIComponent(Ext.encode(exp));
			var upUrl = dhcbaUrl+"/dhcba/formulaverify?exp="+checkStr;
			Ext.Ajax.request({
				//alert(upUrl);
				//autohisoutmedvouchForm.getForm().submit({
				//method : 'POST',
				url:upUrl,
				waitMsg:'��֤��...',
				failure: function(result, request){
					//alert('tmpFal');
					//alert(result.responseText);
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
				},
				success: function(result, request){
					//alert('tmpsucc');
					var jsonData = Ext.util.JSON.decode(result.responseText);
					//alert(result.responseText);
					if(jsonData.info=="success"){
						//return globalStr;
						//m.setValue("���ʽ��ȷ�����Ա��棡");
						//var handler = function(){
						//	expreField.setValue(globalStr); //�ؼ���ʾ
						//	expreDescField.setValue(expdesc.getValue()); //�����ؼ���ʾ
						//	win.close();
						//}
						//Ext.Msg.show({title:'��ʾ',msg:'���ʽ��ȷ!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					formulaTrgg.setValue(globalStr);
					formu=globalStr2;
					win.close();
					}if(jsonData.info=="failure"){
						Ext.Msg.show({title:'��ʾ',msg:'�������������,����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
						//m.setValue("�������������,���飡");
						//globalStr3="";
						//return false;
					}if(jsonData.info=="other"){
						Ext.Msg.show({title:'��ʾ',msg:'���ʽ����,���飡',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
						//m.setValue("���ʽ����,���飡");
						//globalStr3="";
						//return false;
					}
				},
				scope: this
			});		
		}
	});

	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});
	
	//����ȡ���޸İ�ť����Ӧ����
	cancelHandler = function(){
		win.close();
	}
	
	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click',cancelHandler,false);
		
	win = new Ext.Window({
		title: '��ʽ�����',
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
	//������ʾ
	win.show();
}