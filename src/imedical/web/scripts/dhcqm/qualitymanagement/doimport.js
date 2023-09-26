/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *�人�е�һҽԺexcel�ļ��ϴ�����
 */
var doimport = function(){
	var data2="";
	var freStore="";
	
	//��������
	var JournalDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['rowid', 'name'])
	});
			
	JournalDs.on('beforeload', function(ds, o) {	
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
				+'?action=ListschemDr&str='
				+ encodeURIComponent(Ext.getCmp('LocResultMainschemDr').getRawValue())+'&userid='+userid,
			method : 'POST'
		});
	});
	var LocResultMainschemDr = new Ext.form.ComboBox({
		id: 'LocResultMainschemDr',
		fieldLabel: '�����ں�',
		width:200,
		listWidth : 220,
		allowBlank: false,
		store: JournalDs,
		displayField: 'name',
		valueField: 'rowid',
		triggerAction: 'all',
		typeAhead : true,
		//triggerAction : 'all',
		emptyText : '',
		name: 'LocResultMainschemDr',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true
	});
	
	var yearField = new Ext.form.TextField({
		id: 'importyearField',
		fieldLabel:'���',
		width:200,
		regex: /^\d{4}$/,
		regexText:'���Ϊ��λ����',
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'yearField',
		value:(new Date()).getFullYear(),
		minChars: 1,
		pageSize: 10,
		editable:true
	});

	var periodTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['M','��'],['Q','��']]
	});
	var periodTypeField = new Ext.form.ComboBox({
		id: 'importperiodTypeField',
		fieldLabel: '�ڼ�����',
		width:200,
		listWidth : 220,
		selectOnFocus: true,
		allowBlank: false,
		store: periodTypeStore,
		//anchor: '90%',
		value:'Q', //Ĭ��ֵ
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

	periodTypeField.on("select",function(cmb,rec,id){
		if(cmb.getValue()=="M"){
			data=[['','ȫ��'],['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']];
		}
		if(cmb.getValue()=="Q"){
			data=[['01','01����'],['02','02����'],['03','03����'],['04','04����']];
		}
		if(cmb.getValue()=="H"){
			data=[['01','1~6�ϰ���'],['02','7~12�°���']];
		}
		if(cmb.getValue()=="Y"){
			data=[['00','ȫ��']];
		}
		periodStore.loadData(data);
	});
	periodStore = new Ext.data.SimpleStore({
		fields:['key','keyValue']
	});
	periodStore.loadData([['01','01����'],['02','02����'],['03','03����'],['04','04����']]);
	var periodField = new Ext.form.ComboBox({
		id: 'importperiodField',
		fieldLabel: '�ڼ�',
		value:(new Date()).getMonth()<10?"0"+((new Date()).getMonth()+1):((new Date()).getMonth()+1),
		width:200,
		listWidth : 220,
		selectOnFocus: true,
		allowBlank: false,
		//allowBlank: false,
		store: periodStore,
		//anchor: '90%',
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'��ѡ��...',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 12,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});	
	


	//��������ѡ��
	var publicFieldSet = new Ext.form.FieldSet({
		title:'��������ѡ��',
		labelSeparator:'��',
		items:[LocResultMainschemDr,yearField,periodTypeField,periodField]
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
		formId:'formUp',
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
	var importB = new Ext.Button({
		text:'���ݵ���',
		type:'submit'
	});

	
	function callback(id){
	   // alert("22");
		if(id=="yes"){
			//��ȡ������Ϣ
			//LocResultMainschemDr,yearField,periodTypeField,periodField
	//		var periodType=Ext.getCmp('periodType').getValue();
	//		var period=Ext.getCmp('periodField').getValue();
			var schemedr=LocResultMainschemDr.getValue();
			var periodType=periodTypeField.getValue();
			var period=yearField.getValue()+''+periodField.getValue();
			
			var year=yearField.getValue();
				var pattern=/^\d{4}$/;
				if(pattern.test(year)==false){
					Ext.Msg.show({title:'ע��',msg:'��ݸ�ʽ��������λ��Ч����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
					return;}
			if(schemedr==""){
				Ext.Msg.show({title:'��ʾ',msg:'�����ں�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
				return;
			}else if(periodType==""){
				Ext.Msg.show({title:'��ʾ',msg:'�ڼ����Ͳ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
				return;
			}else if(period==""){
				Ext.Msg.show({title:'��ʾ',msg:'�ڼ䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
				return;
			}
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

				//var uploadUrl="http://localhost:8080/uploadexcel/qm/LocResultdetail";
			
				//var uploadUrl="http://localhost:8080/uploadexcel/herp/AcctYear";
//						switch(periodType){
//						  case 'p':uploadUrl="http://localhost:8080/uploadexcel/qm/patient";break;
//						  case 'detail':uploadUrl="http://localhost:8080/uploadexcel/qm/LocResultdetail";break;
//						  default:alert("û��ѡ���");
//						}
			

				var uploadUrl=dhcUrl+"/uploadexcel/qm/LocResultdetail";
				var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType+"&schemedr="+schemedr+"&userid="+userid+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
				//console.log(upUrl);
				formPanel.getForm().submit({
					url:upUrl,
					method:'POST',
					waitMsg:'���ݵ�����, ���Ե�...',
					success:function(form, action) {
						//�жϵ�ǰ�����ʱ��Ϊie������ie11
						var userAgent = navigator.userAgent;   
						var rMsie = /(msie\s|trident.*rv:)([\w.]+)/;   
	
						var ua = userAgent.toLowerCase(); 
						var match = rMsie.exec(ua);  
						if(match != null){
						 // alert("ie");
						if(action.result!=""&& action.result!=undefined){
							Ext.MessageBox.alert("��ʾ��Ϣ","���ݵ���ɹ�!");
						}else{
						    Ext.MessageBox.alert("��ʾ��Ϣ","���ݵ���ʧ��!��������");
						}
					  }else{
							Ext.MessageBox.alert("��ʾ��Ϣ","���ݵ���ɹ�!");
					  }
					},
					failure:function(form, action) {
					
							Ext.MessageBox.alert("Error","���ݵ���ʧ��!");
					}
				});
				
			}		
		}else{
			return;
		}
	}	
			  
	//�������ݹ���
	var handler = function(bt){
		
		if(bt=="yes"){
		
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ������ļ��е�������?',callback);
		}
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ����excel������?',callback);
		
	};

	

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
};