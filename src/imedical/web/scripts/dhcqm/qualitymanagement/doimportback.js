/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *�人�е�һҽԺexcel�ļ��ϴ�����
 */
var doimport = function(){
	var data2="";
	var freStore="";
	
	var pTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['p','������Ϣ��'],['detail','��������������ϸ']]
	});
	var periodType = new Ext.form.ComboBox({
		id: 'periodType',
		fieldLabel: '�����',
		width:210,
	    listWidth : 210,
		selectOnFocus: true,
		allowBlank: false,
		store: pTypeStore,
		//anchor: '90%',
		value:'', //Ĭ��ֵ
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'ѡ����������...',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	var iperiodDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['period'])
	});

	iperiodDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.targetsetexe.csp?action=period&start=0&str='+Ext.getCmp('iperiodField').getRawValue()+'&limit=14',method:'POST'})
	});
	var iperiodField = new Ext.form.ComboBox({
		id: 'iperiodField',
		fieldLabel: '�����ڼ�',
		width:210,
		listWidth : 210,
		//allowBlank: false,
		store: iperiodDs,
		valueField: 'period',
		displayField: 'period',
		triggerAction: 'all',
		emptyText:'��ѡ�񿼺��ڼ�...',
		name: 'periodField',
		minChars: 1,
		pageSize: 10,
		//selectOnFocus:true,
		//forceSelection:'true',
		editable:true
	});

	//��������ѡ��
	var publicFieldSet = new Ext.form.FieldSet({
		title:'��������ѡ��',
		labelSeparator:'��',
		items:[periodType]
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
		//items: [publicFieldSet,upLoadFieldSet,exampleFieldSet]
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
					
					var periodType=Ext.getCmp('periodType').getValue();
					var period=Ext.getCmp('periodField').getValue();

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

						//var uploadUrl = "http://192.167.102.77:8080/uploadexcel/UpLoadValueServlet";
						//var uploadUrl = "http://132.147.160.114:8080/uploadexcel/UpLoadValueServlet";
						var uploadUrl;

						switch(periodType){
						  case 'p':uploadUrl="http://localhost:8080/uploadexcel/qm/patient";break;
						  case 'detail':uploadUrl="http://localhost:8080/uploadexcel/qm/LocResultdetail";break;
						  default:alert("û��ѡ���");
						}
						

						//var uploadUrl = "http://127.0.0.1:8080/uploadexcel/UpLoadValueServlet";
						var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
						
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
								Ext.MessageBox.alert("Error","���ݳɹ�ʧ��!");
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
		title: 'Excel��������',
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