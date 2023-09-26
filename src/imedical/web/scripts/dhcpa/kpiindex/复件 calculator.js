//�༭��ʽ
formula = function(node,type){
	//type=1:��ʾ��Ӳ���
	//type=2:��ʾ�޸Ĳ���
	
	if(type==1){
		//������ʾ
		globalStr = "";
		//���ʽ����
		expreDesc = "";
		//�����˸�
		globalStr2 = "";
		//���ڴ洢
		globalStr3 = "";
		//checkStr = "";
	}
	
	if(type==2){
		//������ʾ
		globalStr = node.attributes.expName;
		//���ʽ����
		expreDesc = node.attributes.expDesc;
		//�����˸�
		globalStr2 = node.attributes.expName2;
		//���ڴ洢
		globalStr3 = node.attributes.expression;
		
	}

	var area = new Ext.form.TextArea({
		id:'area',
		width:500,
		height:100,
		labelWidth:20,
		fieldLabel: '���㹫ʽ',
		readOnly:true
	});
	area.setValue(globalStr);
	var m = new Ext.form.TextField({
		id:'m',
		fieldLabel:'������ʾ',
		allowBlank:true,
		width:700,
		emptyText:'������ձ��ʽ�ٱ༭,�Ա�֤���㹫ʽ��׼ȷ��!',
		anchor:'90%',
		editable:false,
		readOnly:true,
		disabled:true
	});
	var expdesc = new Ext.form.TextField({
		id:'expdesc',
		fieldLabel:'��ʽ����',
		allowBlank: true,
		width:700,
		emptyText:'',
		anchor:'90%',
		selectOnFocus:'true'
	});
		
	expdesc.setValue(expreDesc);
	var kpicomDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});

	kpicomDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.kpiindexexe.csp?action=kpi1&str='+Ext.getCmp('kpicom').getRawValue(),method:'POST'})
	});

	var kpicom = new Ext.form.ComboBox({
		id:'kpicom',
		fieldLabel:'KPI ָ��',
		width:230,
		allowBlank:true,
		store:kpicomDs,
		valueField:'rowid',
		displayField:'name',
		triggerAction:'all',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
		
	var form = new Ext.form.FormPanel({
		title: '��ʽ�༭����',
		listWidth:10,
		fileUpload : true,
		frame:true,
		bodyStyle:'padding:5 5 5 5',
		region:'north',
		height:230,
		labelSeparator:':',
		width:510,
		items:[area,expdesc,m,kpicom]
	});
			
	
			
	kpicom.on("select",function(cmb,rec,id ){
		showValue(cmb.getRawValue(),cmb.getValue());
		kpicom.setValue("");
	});

	function showValue(KPIName,KPIDr){
		globalStr=globalStr+KPIName;
		if(globalStr2==""){
			globalStr2=KPIName+"!"+KPIDr;
		}else{
			globalStr2=globalStr2+"||"+KPIName+"!"+KPIDr;
		}
		area.setValue(globalStr);
	};

	var autohisoutmedvouchForm = new Ext.form.FormPanel({
		listWidth:20,
		title: '��ʽ�༭����',
		region:'center',
		frame:true,
		height:25,
		bodyStyle:'padding:5 5 5 5',
		labelSeparator:':',
		width:550,
		items:[{
			xtype:'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[{
				columnWidth:.05,
				xtype:'button',
				text: '9',
				tooltip:'9', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '8',
				tooltip:'8', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '7',
				tooltip:'7', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '6',
				tooltip:'6', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '5',
				tooltip:'5', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '4',
				tooltip:'4', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '3',
				tooltip:'3', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '2',
				tooltip:'2', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '1',
				tooltip:'1', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '0',
				tooltip:'0', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '.',
				tooltip:'��', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '{',
				tooltip:'�������', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '}',
				tooltip:'�Ҵ�����', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '[',
				tooltip:'��������', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: ']',
				tooltip:'��������', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '(',
				tooltip:'��С����', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: ')',
				tooltip:'��С����', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '+',
				tooltip:'�Ӻ�', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '-',
				tooltip:'����', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '*',
				tooltip:'�˺�', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '/',
				tooltip:'����', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '^',
				tooltip:'ָ��', 
				handler:function(b){
					globalStr=globalStr+this.text;
					if(globalStr2==""){
						globalStr2=this.text;
					}else{
						globalStr2=globalStr2+"||"+this.text;
					}
					area.setValue(globalStr);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: '<-',
				tooltip:'����', 
				handler:function(b){
					var arr = globalStr2.split("||");
					var substr=arr[arr.length-1]; //05��!5
					var sublength=substr.length; //6
					var substrarr=substr.split("!"); 
					var subsubstr=substrarr[0]; //05��
					var subsublength=subsubstr.length; //3
					globalStr=globalStr.substring(0,globalStr.length-subsublength);
					area.setValue(globalStr);
					globalStr2=globalStr2.substring(0,globalStr2.length-sublength-"||".length);
				}
			},{
				columnWidth:.035,
				xtype:'displayfield'
			},{
				columnWidth:.05,
				xtype:'button',
				text: 'C',
				tooltip:'���', 
				handler:function(b){
					globalStr="";
					globalStr2="";
					area.setValue(globalStr);
					m.setValue("");
					expdesc.setValue("");
				}
			}]
		}]
	});

	var OkButton = new Ext.Toolbar.Button({
		text:'ȷ��',
		handler:function(){
				
			//alert(globalStr);
			//alert(globalStr2);
			//���ڸ�ȫ�ֱ���globalStr3(���ڴ洢)��ֵ
			var globalStr4="";
			
			//������ʽ
			var exp="";
			var arr = globalStr2.split("||");
			for(var i=0;i<arr.length;i++){
				var array = arr[i].split("!");
				if(array.length>1){
					//�洢�ַ���
					var id="<"+array[1]+">";
					if(globalStr4==""){globalStr4 = id;}
					else{globalStr4 = globalStr4+""+id;}
					//���ʽ
					var ID=array[1];
					if(exp==""){exp=ID;}
					else{exp = exp+""+ID;}
				}else{
					//�洢�ַ���
					if(globalStr4==""){globalStr4=arr[i];}
					else{globalStr4 = globalStr4+""+arr[i];}
					//��֤���ʽ
					if(exp==""){exp=arr[i];}
					else{exp = exp+""+arr[i];}
				}
			}
			globalStr3 = globalStr4;
			//alert(globalStr3);
			//alert(exp);
			//�����ַ���(ת�봦��)���жϹ�ʽ����ȷ��
			//var exp=encodeURI(encodeURI(globalStr3));
			//var exp=Ext.urlEncode(globalStr3);
				
			//var uploadUrl = "http://127.0.0.1:8080/dhcpaverify/formulaverify";
			var uploadUrl = "http://172.26.253.41:8080/dhcba/formulaverify";
		
			//var exp = encodeURIComponent(Ext.encode(exp));
			
			var upUrl = uploadUrl+"?exp="+exp;
			alert(upUrl);
			//����
			
			
					form.getForm().submit({
								url : upUrl,
								method : 'POST',
								waitMsg : '���ݵ�����, ���Ե�...',
								success : function(form, action, o) {

							expreField.setValue(globalStr); //�ؼ���ʾ
							expreDescField.setValue('"'_expdesc.getValue()_'"'); //�����ؼ���ʾ
							win.close();

								},
								failure : function(form, action) {
									// Ext.MessageBox.alert("��ʾ��Ϣ",

									if (jsonData.info == "failure") {
										Ext.Msg.show({
													title : '��ʾ',
													msg : '�������������,����!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});

									}
									if (jsonData.info == "other") {
										Ext.Msg.show({
													title : '��ʾ',
													msg : '���ʽ����,���飡',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});

									}

								}
							});
			
			
/**
			form.getForm().submit({
		
				url:upUrl,
				waitMsg:'������...',
				fileUpload : true,
				
				failure: function(response){
				
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					globalStr3="";
				},
				success: function(response){
		
					//var jsonData = Ext.util.JSON.decode(response.responseText);
					alert("1111");
					if(jsonData.info=="success"){
						m.setValue("���ʽ��ȷ�����Ա��棡");
						
						var handler = function(){
							//alert(globalStr);
							expreField.setValue(globalStr); //�ؼ���ʾ
							expreDescField.setValue(expdesc.getValue()); //�����ؼ���ʾ
							win.close();
						}
						Ext.Msg.show({title:'��ʾ',msg:'���ʽ��ȷ!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:handler,width:250});
					}if(jsonData.info=="failure"){
						m.setValue("�������������,���飡");
						globalStr3="";
						return false;
					}if(jsonData.info=="other"){
						m.setValue("���ʽ����,���飡");
						globalStr3="";
						return false;
					}
					
				},
				scope: this
			});		
		**/	
		}
		/////////////////////////////////////////////
		/**
			text : 'ȷ��',
				handler : function() {

					var upUrl = dhcbaUrl + "/dhcba/formulaverify?exp="
							+ checkStr;

					var upUrl = dhcbaUrl + "/dhcba/formulaverify?exp="
							+ encodeURIComponent(checkStr);

					// prompt('upUrl', upUrl)

					formSet.getForm().submit({
								url : upUrl,
								method : 'POST',
								waitMsg : '���ݵ�����, ���Ե�...',
								success : function(form, action, o) {

								expreField.setValue(globalStr); //�ؼ���ʾ
								expreDescField.setValue(expdesc.getValue()); //�����ؼ���ʾ
								win.close();

								},
								failure : function(form, action) {
									// Ext.MessageBox.alert("��ʾ��Ϣ",

									if (jsonData.info == "failure") {
										Ext.Msg.show({
													title : '��ʾ',
													msg : '�������������,����!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});

									}
									if (jsonData.info == "other") {
										Ext.Msg.show({
													title : '��ʾ',
													msg : '���ʽ����,���飡',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});

									}

								}
							});

				}
		
		
		
		
		**/
	});

/////////////////////////////////


	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});
	
	//����ȡ���޸İ�ť����Ӧ����
	cancelHandler = function(){
		win.close();
	}
	
	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click',cancelHandler,false);
		
	win = new Ext.Window({
		title: 'ָ�깫ʽ�༭��',
		width: 715,
		height:390,
		minWidth: 715, 
		minHeight: 390,
		layout:'border',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:[form,autohisoutmedvouchForm],
		buttons:[
			OkButton,
			cancelButton
		]
	});
	//������ʾ
	win.show();
}