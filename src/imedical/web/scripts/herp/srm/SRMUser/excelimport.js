/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *�人�е�һҽԺexcel�ļ��ϴ�����
 */
var importExcel = function(){
	//var uploadUrl = "http://10.0.1.142:8080/uploadexcel/ImportExcelByIdServlet";
  var uploadUrl = "http://127.0.0.1:8080/uploadexcel/ImportHERPTRCourseExamServlet";
  //var uploadUrl = "http://127.0.0.1:8080/uploadexcel/ImportExcelByIdServlet";
	var data2="";
	var freStore="";

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
		items: [upLoadFieldSet,exampleFieldSet]
		//buttons:[{text:'����Excel����',handler:handler}]
	});
	
importdata=function(){
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ����excel������?',
			function(btn) {
	    	    if(btn == 'yes')
		        {	
					//�ж��Ƿ���ѡ�����Ҫ�ϴ���excel�ļ�
					var excelName = Ext.getCmp('excelUpload').getRawValue();//�ϴ��ļ����Ƶ�·��
					if(excelName==""){
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Excel�ļ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
						return;
					}else{ 
						Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ������ļ��е�������?',
						function(id){
							if(id=='yes')
							{
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
						//alert("filename"+fileName.substring(fileName.lastIndexOf(".")+1));
						//var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
						//alert(upUrl);
								var grade=3;
								var year=2;
								var upUrl = uploadUrl+"?year="+year;
								//var upUrl = uploadUrl;
								alert(upUrl);
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
							}else{
								return;
							}
						})
				    }  
				}else{
				return;
			}
		});
	} 
	//���尴ť
	var importB = new Ext.Toolbar.Button({
		text:'���ݵ���',
		tooltip:'���ݵ���',        
        iconCls:'import',
	    handler:function(){
	        importdata();		
	}
	});
	
	
/*
	//�������ݹ���
	var handler = function callback1(bt){
		if(bt=="yes"){
			alert("22"); 
			function callback(id){
				if(id=="yes"){
					
					//�ж��Ƿ���ѡ�����Ҫ�ϴ���excel�ļ�
					var excelName = Ext.getCmp('excelUpload').getRawValue();//�ϴ��ļ����Ƶ�·��
					alert(excelName);
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
						//alert("filename"+fileName.substring(fileName.lastIndexOf(".")+1));
						//var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
						//alert(upUrl);
						var upUrl = uploadUrl;
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
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ����excel������?',callback1);
	} 


*/
	var window = new Ext.Window({
		title: '����excel����',
		iconCls:'import',
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