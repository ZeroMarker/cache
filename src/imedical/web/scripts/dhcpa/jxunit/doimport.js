/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *�人�е�һҽԺexcel�ļ��ϴ�����
 */
var doimport = function(){
	var data2="";
	var freStore="";
	
	var excelUpload = new Ext.form.TextField({   
		id:'excelUpload', 
		name:'Excel',   
		anchor:'98%',   
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
		//width:325,
		anchor:'98%', 
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
		//height:200,
		//width:500,
		frame:true,
		fileUpload:true,
		//applyTo:'form',
		//items: [publicFieldSet,upLoadFieldSet,exampleFieldSet]
		//items: [upLoadFieldSet,exampleFieldSet]
		//buttons:[{text:'����Excel����',handler:handler}]
		items:[excelUpload,textArea]  //2016-6-30 cyl
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
				var uploadUrl="http://localhost:8080/uploadexcel/pa.JxunitImport";
				//var uploadUrl="http://localhost:8080/uploadexcel/herp/AcctYear";
//						switch(periodType){
//						  case 'p':uploadUrl="http://localhost:8080/uploadexcel/qm/patient";break;
//						  case 'detail':uploadUrl="http://localhost:8080/uploadexcel/qm/LocResultdetail";break;
//						  default:alert("û��ѡ���");
//						}
			

				//var uploadUrl = "http://127.0.0.1:8080/uploadexcel/UpLoadValueServlet";
				var upUrl = uploadUrl+"?fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
				//alert(upUrl);
				//alert(fileName);
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
		width: 500,
		height:200,
		minWidth: 500,
		minHeight: 200,
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