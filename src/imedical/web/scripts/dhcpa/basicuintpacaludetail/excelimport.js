/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *�人�е�һҽԺexcel�ļ��ϴ�����
 */
var importExcel = function(){
	//var uploadUrl = "http://10.0.1.142:8080/uploadexcel/ImportExcelByIdServlet";
  var uploadUrl = "http://127.0.0.1:8080/excel/uploadZYYExcel";
  //var uploadUrl = "http://127.0.0.1:8080/uploadexcel/ImportExcelByIdServlet";
	var data2="";
	var freStore="";
	var cDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
	});

	cDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('cycle').getRawValue()+'&active=Y',method:'POST'})
	});

	var cycle = new Ext.form.ComboBox({
		id: 'cycle',
		fieldLabel:'��������',
		//width:180,
		//listWidth : 180,
		allowBlank: false,
		store: cDs,
		valueField: 'code',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ�񿼺�����...',
		name: 'cycleField',
		minChars: 1,
		anchor: '90%',
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true
	});
	
	var pTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['M','M-��'],['Q','Q-��'],['H','H-����'],['Y','Y-��']]
	});
	var periodType = new Ext.form.ComboBox({
		id: 'periodType',
		fieldLabel: '�ڼ�����',
		//width:180,
		//listWidth : 180,
		selectOnFocus: true,
		allowBlank: false,
		store: pTypeStore,
		anchor: '90%',
		value:'', //Ĭ��ֵ
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'ѡ���ڼ�����...',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	periodType.on("select",function(cmb,rec,id){
		if(cmb.getValue()=="M"){
			data2=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
		}
		if(cmb.getValue()=="Q"){
			data2=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
		}
		if(cmb.getValue()=="H"){
			data2=[['1','1~6�ϰ���'],['2','7~12�°���']];
		}
		if(cmb.getValue()=="Y"){
			data2=[['0','ȫ��']];
		}
		pStore.loadData(data2);
	});
	pStore = new Ext.data.SimpleStore({
		fields:['key','keyValue']
	});

	var period = new Ext.form.ComboBox({
		id: 'period',
		fieldLabel: '�ڼ�ֵ',
		//width:180,
		//listWidth : 180,
		selectOnFocus: true,
		allowBlank: false,
		store: pStore,
		anchor: '90%',
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'��ѡ���ڼ�ֵ...',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	//��������ѡ��
	var publicFieldSet = new Ext.form.FieldSet({
		title:'��������ѡ��',
		labelSeparator:'��',
		items:[cycle,periodType,period]
	});
	
	var excelUpload = new Ext.form.TextField({   
		id:'excelUpload', 
		name:'Excel',   
		anchor:'90%',   
		height:20,   
		inputType:'file',
		fieldLabel:'�ļ�ѡ��'
	});
				
	//�ļ�ѡ��
	var upLoadFieldSet = new Ext.form.FieldSet({
		title:'�ļ�ѡ��',
		labelSeparator:'��',
		items:[excelUpload]
	});
				
	//���ı���
	var textArea = new Ext.form.TextArea({
		id:'textArea',
		width:325,
		fieldLabel:'�Ѻ���ʾ',
		readOnly:true,
		disabled:true,
		emptyText:'����ϸ�˶�Ҫ�������ݵĸ�ʽ�Լ����ݵ���Ч�ԣ�'
	});

	//����˵�����ı���
	var exampleFieldSet = new Ext.form.FieldSet({
		title:'���ݵ���������ʾ',
		labelSeparator:'��',
		items:textArea
	});

	var formPanel = new Ext.form.FormPanel({
		//title:'Excel���ݵ���',
		labelWidth:80,
		bodyStyle:'padding:5 5 5 5',
		height:515,
		width:515,
		frame:true,
		fileUpload:true,
		//applyTo:'form',
		items: [publicFieldSet,upLoadFieldSet,exampleFieldSet]
		//buttons:[{text:'����Excel����',handler:handler}]
	});
			
	//���尴ť
	var importB = new Ext.Toolbar.Button({
		text:'���ݵ���'
	});
			
	//�������ݹ���
	var handler = function(bt){
		if(bt=="yes"){
			function callback(id){
				if(id=="yes"){
					//��ȡ������Ϣ
					var cycleCode=Ext.getCmp('cycle').getValue();
					var periodType=Ext.getCmp('periodType').getValue();
					var period=Ext.getCmp('period').getValue();
					if(period<10){
						period="0"+period;
					}
					var period=cycleCode+period;
					//�ж��Ƿ���ѡ�����Ҫ�ϴ���excel�ļ�
					var excelName = Ext.getCmp('excelUpload').getRawValue();//�ϴ��ļ����Ƶ�·��
					if(excelName==""){
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Excel�ļ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
						return;
					}else{ 
						var array=new Array();
						array=excelName.split("\\");
						var fileName="";
						var i=0;
						for(i=0;i<array.length;i++){
							if(fileName==""){
								fileName=array[i];
							}else{
								fileName=fileName+"/"+array[i];
							}
						}
						var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType;
						//alert(upUrl);
						formPanel.getForm().submit({
							url:upUrl,
							method:'POST',
							waitMsg:'���ݵ�����, ���Ե�...',
							success:function(form, action, o) {
								Ext.MessageBox.alert("��ʾ��Ϣ","���ݳɹ�����!");
								//Ext.MessageBox.alert("Information",action.result.mess);
							},
							failure:function(form, action) {
								Ext.MessageBox.alert("Error",action.result.mess);
							}
						});					
					}		
				}else{
					return;
				}
			}
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ������ļ��е�������?',callback);
		}
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ����excel������?',callback);
	} 

	//��Ӱ�ť����Ӧ�¼�
	importB.addListener('click',handler,false);

	var window = new Ext.Window({
		title: '�������ָ������',
		width: 530,
		height:400,
		minWidth: 530,
		minHeight: 400,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			importB
		]
	});
	window.show();
}