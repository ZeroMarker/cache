var doimport = function(importFields){

var URL="";
	 Ext.Ajax.request({
        url:'../csp/herp.acct.acctsubjledgerexe.csp?action=GetURL&bookID='+ bookID,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
        if (jsonData.success=='true'){
			URL= jsonData.info;	
		
			//alert(URL);
                  }
             }
			 
});

//var importField=importField.getValue();
	var excelUpload = new Ext.form.TextField({   
		id:'excelUpload', 
		name:'Excel',   
		anchor:'90%',
		region:'right',
		height:25,   
		inputType: 'file',
		fieldLabel:'�ļ�ѡ��',
		width:40
		
	});

var info="";
if(importFields==1){
	var info="ע�⣺��ѡ���������ڳ�����ģ��";
	}else{
	var info="ע�⣺��ѡ����ҽ���ڳ����ݵ���ģ��";
		}
				
	//�ļ�ѡ��
	var upLoadFieldSet = new Ext.form.FieldSet({
		title:'�ļ�ѡ��',
		labelSeparator:'��',
		height:130,
		//bodyStyle:'padding:10px;',
		align:'center',
		items:[excelUpload],
		html:"<br/><span  style='color:red;padding:15px'>"+info+"</span>"
	});
				
	//���ı���
	var textArea = new Ext.form.TextArea({
		id:'textArea',
		width:325,
		fieldLabel:'�Ѻ���ʾ',
		readOnly:true,
		disabled:true,
		emptyText:'1.������ϸ�˶���Ҫ�������ݵĸ�ʽ����֤���ݵ���Ч�ԣ�������ɲ���Ҫ�Ĵ���'
	
	});

	//����˵�����ı���
	var exampleFieldSet = new Ext.form.FieldSet({
		title:'���ݵ���������ʾ',
		labelSeparator:'��',
		//bodyStyle:'padding:10px;',
		align:'center',
		items:textArea
	});

	var formPanel = new Ext.form.FormPanel({
		//title:'Excel���ݵ���',
		formId:'formUp',
		labelWidth:80,
		labelAlign:'right',
		bodyStyle:'padding:10 10 10 10',
		height:515,
		width:515,
		frame:true,
		fileUpload:true,
		items: [exampleFieldSet,upLoadFieldSet]
	});
			
	//���尴ť
	var importB = new Ext.Button({
		text:'���ݵ���',
		iconCls:'in',
		type:'submit'
	});

	//var importField=importField.getValue();
	function callback(id){
	   // alert("22");
		if(id=="yes"){
			//��ȡ������Ϣ
		//alert(importFields);
		
			
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

		if (importFields==1){
				 
			//var uploadUrl="http://192.168.5.4:8080/herp.acct.importExcel/AcctLedgerServlet";
		    var uploadUrl="http://"+URL+"/herp.acct.importExcel/AcctLedgerServlet";
			var upUrl=uploadUrl+"?AcctBookID="+bookID+"&userdr="+userdr+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
		}else if(importFields==2){
						
		    //var uploadUrl="http://192.168.5.4:8080/herp.acct.importExcel/AcctCheckLedgerServlet";
			var uploadUrl="http://"+URL+"/herp.acct.importExcel/AcctCheckLedgerServlet";
			var upUrl=uploadUrl+"?AcctBookID="+bookID+"&userdr="+userdr+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);			
		}
			
			
				
		

				formPanel.getForm().submit({
					url:upUrl,
					method:'POST',
					waitMsg:'���ݵ�����, ���Ե�...',
					success:function(form, action) {
						//console.log(action)

						//�жϵ�ǰ�����ʱ��Ϊie������ie11
						var userAgent = navigator.userAgent;   
						var rMsie = /(msie\s|trident.*rv:)([\w.]+)/;   
	
						var ua = userAgent.toLowerCase(); 
						var match = rMsie.exec(ua);  
						if(match != null){
						  //alert(action.result.success);
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
		width: 520,
		height:325,
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