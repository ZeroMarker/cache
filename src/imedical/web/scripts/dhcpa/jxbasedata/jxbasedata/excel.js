/**
  *name:tab of database
  *author:wang ying
  *Date:2010-12-14
  *excel�ļ��ϴ�����
 */
var uploadExcel = function(){
			var excelUpload = new Ext.form.TextField({   
				id:'excelUpload', 
				name:'Excel',   
				anchor:'90%',   
				height:20,   
				inputType:'file',
				fieldLabel:'�ļ�ѡ��'
			});
			
			
			//������Ŀѡ��
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
		/*	
		var PeriodField = new Ext.form.TextField({
			id:'PeriodField',
			fieldLabel: '�����ڼ�',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'����д�����ڼ�...',
			anchor: '90%',
			selectOnFocus:'true'
		});
		*/
		var formPanel = new Ext.form.FormPanel({
			//title:'Excel���ݵ���',
			labelWidth:80,
			bodyStyle:'padding:5 5 5 5',
			height:500,
			width:503,
			frame:true,
			fileUpload:true,
			//applyTo:'form',
			items: [upLoadFieldSet,exampleFieldSet]
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
								var uploadUrl = "http://172.16.2.20:8080/uploadexcel/uploadexcel";
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
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ����excel������?',callback);
			} 
		//��Ӱ�ť����Ӧ�¼�
		importB.addListener('click',handler,false);

		var win = new Ext.Window({
			title: '�������ָ������',
			width: 515,
			height:320,
			minWidth: 515,
			minHeight: 320,
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
		win.show();
		
}