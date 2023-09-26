userid=session['LOGON.USERID'];
var projUrl = '../csp/dhc.qm.qualityinfomanagementexe.csp';

addFun=function(){
	//===========����========
	var checkDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
	checkDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
					
							url : CheckCoefficientTabUrl+'?action=ListCheck&str='
								+ encodeURIComponent(Ext.getCmp('checkField').getRawValue())+'&schemdr='+encodeURIComponent(Ext.getCmp('SchemeField').getValue()),
						method : 'POST'
					});
		});
var checkCom = new Ext.form.ComboBox({
	id: 'checkField',
	fieldLabel: '����',
	width:240,
	listWidth : 240,
	resizable:true,
	allowBlank: false,
	store: checkDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '��ѡ�����',
	name: 'LocResultdetailcheckDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
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
	url:CheckCoefficientTabUrl+'?action=ListschemDr&str='+encodeURIComponent(Ext.getCmp('SchemeField').getRawValue())+'&userid='+userid,
	method:'POST'});
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
	checkDs.load({params:{start:0,limit:10,schemdr:SchemeField.getValue()}});
});

	
var coefficientFiled =new Ext.form.Field({
		fieldLabel:"����ֵ",
		id:"coefficient",
		inputType:'text',
		width:102	
	});
	var betweenAnd = new Ext.form.DisplayField({			
			id:'and',
			style:'padding-top:3px;',
			value: '&nbsp;&nbsp;and&nbsp;&nbsp;&nbsp;'
				
		});
	var coefficientFiled2 =new Ext.form.Field({
		fieldLabel:"����ֵ��",
		id:"coefficient2",
		inputType:'text',
		
		width:102	
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
		emptyText:'��ѡ�����...',
		name: 'comField',
		minChars: 1,
		editable:true,
		resizable:true
	}); 
	
	//���水ť
	var saveBtn = new Ext.Button({
		text:'����',
		//iconCls:'save',
		handler:function(){
			//��ȡֵ
			var schemDr = Ext.getCmp('SchemeField').getValue();
			var checkDr = Ext.getCmp('checkField').getValue();
			var com = Ext.getCmp('comField').getValue();
			var coefficient = encodeURIComponent(Ext.getCmp('coefficient').getRawValue());
			var coefficient2=Ext.getCmp("coefficient2").getValue();
			
			if(coefficient2!=""){
				var data = schemDr+"^"+checkDr+"^"+com+"^"+coefficient+"and"+coefficient2
			}else{
				var data = schemDr+"^"+checkDr+"^"+com+"^"+coefficient
			}
			//alert(data);
			Ext.Ajax.request({
				url:CheckCoefficientTabUrl+'?action=add&dataStr='+data,
				success:function(result,request){
					//console.log(result);
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						CheckCoefficientTabDs.load({params:{start:0, limit:page.pageSize}});
					}else if(jsonData.info=="hasCheck"){
						
						Ext.Msg.show({title:'����',msg:'�ü����Ѿ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						
					}else{
						
						Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						
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
			
			coefficientFiled2.show();
			Ext.getCmp("and").show();
			$("#coefficient").attr("style","width:102px;");
			$("#coefficient2").attr("style","width:102px;");
			
		}else{
			coefficientFiled2.hide();
			Ext.getCmp("and").hide();
			$("#coefficient").attr("style","width:240px;");
		}
	});
	
	//��������
	var addWin = new Ext.Window({
		title:"��������ֵ",
		height:250,
		width:350,
		//plain : true,
		modal : true,
		//bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items:[formPanel],
		buttons: [saveBtn,cancleBtn]
	});
	
	addWin.show();
	
	
}