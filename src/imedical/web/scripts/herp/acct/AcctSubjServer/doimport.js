
var doimport = function(){
	var data2="";
	var freStore="";
	
   var URL="";
	 Ext.Ajax.request({
        url:'../csp/herp.acct.acctsubjserverexe.csp?action=GetURL&acctbookid='+ acctbookid,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
        if (jsonData.success=='true'){
			URL= jsonData.info;	
		
                  }
             }
			 
});



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
				
	//�ļ�ѡ��
	var upLoadFieldSet = new Ext.form.FieldSet({
		title:'�ļ�ѡ��',
		labelSeparator:'��',
		height:100,
		bodyStyle:'padding:15px;',
		align:'center',
		items:[excelUpload]
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

//==========================//

	/*
	for(var i = 0; i < len; i++){   
			var rowid=rowObj[i].get("rowid");
			Ext.Ajax.request({
				url:'herp.acct.acctsubjserverexe.csp?action=delsj&rowid='+rowid,
				waitMsg:'ɾ����...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						CheckitemGrid.load({params:{start:0,limit:25}});
					}else{
						Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});	
			}


*/



//=========================//














	
	function callback(id){
		if(id=="yes"){
			//��ȡ������Ϣ
			//LocResultMainschemDr,yearField,periodTypeField,periodField
	//		var periodType=Ext.getCmp('periodType').getValue();
	//		var period=Ext.getCmp('periodField').getValue();
	//		var schemedr=LocResultMainschemDr.getValue();
	//		var periodType=periodTypeField.getValue();
	//		var period=yearField.getValue()+''+periodField.getValue();
			/*  //======����ѡ���ж�======//
			if(schemedr==""){
				Ext.Msg.show({title:'��ʾ',msg:'�����ں�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
				return;
			}else if(periodType==""){
				Ext.Msg.show({title:'��ʾ',msg:'�ڼ����Ͳ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
				return;
			}else if(period==""){
				Ext.Msg.show({title:'��ʾ',msg:'�ڼ䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
				return;
			} */
			
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
				var uploadUrl="http://"+URL+"/herp.acct.importExcel/herp/AcctSubj";
				//var uploadUrl="http://192.168.5.4:8080/herp.acct.importExcel/herp/AcctSubj";
				
				//����Ӧ����һ���������Ķ�����
			//	var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType+"&schemedr="+schemedr+"&userid="+userid+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
			var upUrl=uploadUrl+"?acctbookid="+acctbookid+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
		
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