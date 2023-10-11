
var doimport = function(){
	var data2="";
	var freStore="";
	var URL="";
	 Ext.Ajax.request({
        url:'../csp/herp.acct.acctbankcheckexe.csp?action=GetURL&acctbookid='+ acctbookid,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
        if (jsonData.success=='true'){
			URL= jsonData.info;	
                  }
             }
			 
});


var SubjNameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['SubjCode','SubjName','SubjName3'])
});

SubjNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetBankNameim&userdr='+userdr+'&acctbookid='+acctbookid+'&str='+encodeURIComponent(Ext.getCmp('SubjNameIm').getRawValue()),method:'POST'});
});

var SubjNameIm = new Ext.form.ComboBox({
	id: 'SubjNameIm',
	fieldLabel: '��ѡ��ģ��',

	width:160,
	listWidth : 220,
	allowBlank: true,
	store: SubjNameDs,
	valueField: 'SubjName3',
	displayField: 'SubjName',
	triggerAction: 'all',
	emptyText:'���п�Ŀ',
	name: 'SubjNameIm',
	minChars: 0,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var SubjNameImSet = new Ext.form.FieldSet({
		title:'ģ��ѡ��',
		bodyStyle:'padding:10px 15px 10px 30px;',
		labelSeparator:'��',
		align:'center',
		items:[SubjNameIm]
	})


	var excelUpload = new Ext.form.TextField({   
		id:'excelUpload', 
		name:'Excel',   
		anchor:'80%',
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
		emptyText:'������ϸ�˶���Ҫ�������ݵĸ�ʽ����֤���ݵ���Ч�ԣ�������ɲ���Ҫ�Ĵ���'
	
	});

	//����˵�����ı���
	var exampleFieldSet = new Ext.form.FieldSet({
		title:'���ݵ���������ʾ',
		labelSeparator:'��',
		bodyStyle:'padding:10px 15px 10px 15px;',
		items:textArea,
		HeightAuto:true
	});

	var formPanel = new Ext.form.FormPanel({
		//title:'Excel���ݵ���',
		formId:'formUp',
		labelWidth:90,
		labelAlign:'right',
		bodyStyle:'padding:5 5 5 5',
		height:530,
		width:515,
		frame:true,
		fileUpload:true,
		items: [SubjNameImSet,upLoadFieldSet,exampleFieldSet]
	});
			
	//���尴ť
	var importB = new Ext.Button({
		text:'���ݵ���',
		iconCls:'in',
		type:'submit'
	});

	
	function callback(id){
	   // alert("22");
		if(id=="yes"){
			//��ȡ������Ϣ
	var AcctSubjName=SubjNameIm.getValue();
			if(AcctSubjName==""){
				Ext.Msg.show({title:'��ʾ',msg:'ģ�岻��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
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

				//var uploadUrl = "http://192.168.5.4:8080/herp.acct.importExcel/BankCheckServlet";
				var uploadUrl = "http://"+URL+"/herp.acct.importExcel/BankCheckServlet";
				//alert(uploadUrl);
				var upUrl = uploadUrl+"?AcctSubjName="+AcctSubjName+"&acctbookid="+acctbookid+"&userdr="+userdr+ "&fileType="
						+ fileName.substring(fileName.lastIndexOf(".") + 1);
			

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
					        // itemGrid.reload();
						}else{
						    Ext.MessageBox.alert("��ʾ��Ϣ","���ݵ���ʧ��!��������");
						}
					  }else{
							Ext.MessageBox.alert("��ʾ��Ϣ","���ݵ���ɹ�!");
					       //  itemGrid.reload();
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
		height:380,
		minWidth: 530,
		minHeight: 450,
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