var userid = session['LOGON.USERID'];	
var projUrl='../csp/herp.acct.acctcashflowitemmainexe.csp';	


funadd = function() {	
	
	//��Ŀ����
	var CIlevelDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [
				['1','1��'],['2','2��'],['3','3��'],['4','4��'],
				['5','5��'],['6','6��'],['7','7��'],['8','8��']
			]
		});
		var CIlevelfield= new Ext.form.ComboBox({
			id : 'CIlevelfield',
			fieldLabel : '��Ŀ����',
			width : 230,
			selectOnFocus : true,
			allowBlank : false,
			//value : 1,
			blankText :"��ѡ�����Ŀ����Ŀ����",
			store : CIlevelDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			emptyText:'��ѡ����Ŀ����...',
			selectOnFocus : true,
			forceSelection : true,
			listeners:{
				select:function(){
					var levels=CIlevelfield.getValue()
					if(levels==1) {SupNumberField.disable();}
					else SupNumberField.enable();
					
				}
			}
		});	


	
	//��Ŀ���� 
	var CICodeField = new Ext.form.TextField({
		fieldLabel: '��Ŀ����',
		width:230,
		allowBlank : false,  
		blankText :"��¼�����Ŀ����Ŀ����",
		selectOnFocus:'true',
		regex :/(^[A-Za-z0-9]+$)/,
		emptyText:'��¼����Ŀ����...',
			listeners : {
			specialKey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (CICodeField.getValue() != "") {
						//CINameField.focus(true);
					} else {
						Handler = function() {
							CICodeField.focus();
						}
						Ext.Msg.show({
							title : '��ʾ',
							msg : '��¼�����Ŀ����Ŀ���� ',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING,
							fn : Handler
						});
					}
				}
			}
		}
	});
	
	
	//��Ŀ���� 
	var CINameField = new Ext.form.TextArea({
		fieldLabel: '��Ŀ����',
		width:230,
		//height:'auto', 
		height:40, 
		style:'overflow:hidden',
		allowBlank : false,
		blankText :"��¼�����Ŀ����Ŀ����",
		emptyText:'��¼����Ŀ����...', 
		//anchor: '95%',
		selectOnFocus:'true',
		listeners : {
			specialKey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (CINameField.getValue() != "") {
						SupNumberField.focus();
					} else {
						Handler = function() {
							CINameField.focus();
						}
						Ext.Msg.show({
							title : '��ʾ',
							msg : '��¼�����Ŀ����Ŀ���� ',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING,
							fn : Handler
						});
					}
				}
			}
		}
	});
	

 //�ϼ�����  
	    	var SupNumberField = new Ext.form.TextField({
						id: 'SupNumberField',
						fieldLabel: '�ϼ�����',
						width:230,
						allowBlank : false,  
						blankText :"��¼�����Ŀ���ϼ�����",
						selectOnFocus:'true',
						regex :/(^[A-Za-z0-9]+$)/,
						emptyText:'��¼���ϼ�����...',
						listeners : {
			specialKey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (SupNumberField.getValue() != "") {
						IsStopFieldDs.focus();
					} else {
						Handler = function() {
							SupNumberField.focus();
						}
						Ext.Msg.show({
							title : '��ʾ',
							msg : '��¼�����Ŀ���ϼ����� ',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING,
							fn : Handler
						});
					}
				}
			}
		}
					});	
	
	
	
	//�Ƿ�ͣ�� 
	
		var IsStopFieldDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��'], ['0', '��']]
		});
		var IsStopField = new Ext.form.ComboBox({
			id : 'IsStopField',
			fieldLabel : '�Ƿ�ͣ��',
			width:230, 
			selectOnFocus : true,
			value :0,
			allowBlank : false,
			blankText :"��ѡ�����Ŀ�Ƿ�ͣ��",
			store : IsStopFieldDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			emptyText:'��ѡ���Ƿ�ͣ��...',
			selectOnFocus : true,
			forceSelection : true
		});	
		
		
		//�Ƿ�ĩ��
	var IsLastFieldDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��'], ['0', '��']]
		});
		var IsLastField = new Ext.form.ComboBox({
			id : 'IsLastField',
			fieldLabel : '�Ƿ�ĩ��',
			width:230, 
			value : 1,
			selectOnFocus : true,
			allowBlank : false,
			blankText :"��ѡ�����Ŀ�Ƿ�Ϊĩ��",
			store : IsLastFieldDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			emptyText:'��ѡ���Ƿ�ĩ��...',
			selectOnFocus : true,
			forceSelection : true,
			listeners:{
				select:function(){
					var last=IsLastField.getValue()
					if(last==1) {MoneyFlowField.enable();}
					else MoneyFlowField.disable();
				}
			}
		});	
			
			
	           ////��������   
		var MoneyFlowDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '����'], ['1', '����']]
		});
	
		var MoneyFlowField = new Ext.form.ComboBox({
			    id : 'MoneyFlowField',
				fieldLabel : '��������',
				width : 230,
				allowBlank : false,
				value : 0,
				blankText :"��ѡ�����Ŀ����������",
				store : MoneyFlowDs,		
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '��ѡ����������...',
				mode : 'local', // ����ģʽ
				editable : false,
				//value:1,
				selectOnFocus : true,
				forceSelection : true
				// disabled:true
		});	
			
		var CISpellField = new Ext.form.TextField({
				fieldLabel: 'ƴ����',
				width:230,
				allowBlank : true,	
				emptyText : '���Զ�����...',
				selectOnFocus:'true',
                regex :/(^[A-Za-z]+$)/,
				listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
                                                               
									//familyname.focus();
								}
								}}
			});

			Ext.apply(Ext.form.VTypes,{password:function(val,field){   
                if(field.confirmTo){   
                    var pwd=Ext.get(field.confirmTo);                     
                    if(val.trim()== pwd.getValue().trim()){   
                        return true;   
                    }   
                    else   
                    {   
                        return false;   
                    }   
                    return false;   
                    }   
                }   
              }); //����Ǳ�Ҫ��  
		
		
	
    
	
		var SJFieldSet = new Ext.form.FieldSet({
		//title : '�ֽ�������Ŀά��',
		height : 255,
		columnWidth:1,
		bodyStyle:"padding:10px 40px 0px",
		layout:'column',
		labelSeparator : ':',
		items : [{
			//columnWidth:1,
			layout:'form',
			items: [
					{
						xtype : 'displayfield',
						value : ''
						//columnWidth :.05
					},
					CIlevelfield, 
					CICodeField,
					CINameField,        
					SupNumberField,
					//IsStopField,   
					IsLastField,     
					MoneyFlowField					
					]	
		}
		]
	});


//***����ṹ***// 
	var colItems =	[{
		layout: 'column',
		//border: false,
		defaults: {
			columnWidth: '1.0',
			bodyStyle:'padding:2px 3px 2px',
			border: false
			},            
		    items:[{
			xtype: 'fieldset',
			//autoHeight: true,
			items:[
				SJFieldSet
			]
		}]
	}];
	
	//***�������(���)***//
	var formPanel = new Ext.form.FormPanel({
		labelWidth: 70,
		frame: true,
		items: colItems
	});
	
	//***��Ӱ�ť***//
	addButton = new Ext.Toolbar.Button({
		text:'����',
		iconCls:'save'
	});


	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
	addHandler = function(){ 
	var level  =  CIlevelfield.getValue();   //��Ŀ����
	var name   =  CINameField.getValue();    //��Ŀ����
	var code   =  CICodeField.getValue();    //��Ŀ����
	var supers =  SupNumberField.getValue(); //�ϼ�����
	var isStop = IsStopField.getValue();
	var islast = IsLastField.getValue();
	var direct = MoneyFlowField.getValue();
	// var isStop = (IsStopField.getValue() == true) ? '1' : '0';    //�Ƿ�ͣ��
	// var islast = (IsLastField.getValue() == true) ? '1' : '0';    //�Ƿ�ĩ��
	// var direct = (MoneyFlowField.getValue() == true) ? '1' : '0'; //��������
	var spell  =  CISpellField.getValue();    //ƴ����
	
if((name=="")||(code==""))
	{
		Ext.Msg.show({title:'��ʾ',msg:'��������Ʋ���Ϊ��! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	};
/*if(isStop=="")
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ�����Ŀ�Ƿ�ͣ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	};*/
if(islast=="")
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ�����Ŀ�Ƿ�Ϊĩ��! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	};		

	
   /* var len2=0;
	var flag=1;
	Ext.Ajax.request({
		    async: false,
			url: '../csp/herp.acct.acctcashflowitemmainexe.csp?action=GetLength&acctbookid='+acctbookid+'&level='+level,
			waitMsg:'������...',
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					 len2= jsonData.info;
					 var len  = code.length;
					if(len!=len2){
					Ext.Msg.show({title:'����',msg:'��Ŀ���벻�淶',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					flag=2;
					return;
					};
				}
			}
	});*/
	
	var data = code + "|" + name + "|" + supers + "|" + level + "|" + islast + "|" + isStop + "|" + direct + "|" + spell
	
	if(formPanel.form.isValid()){
	Ext.Ajax.request({
			url: '../csp/herp.acct.acctcashflowitemmainexe.csp?action=add&data='+encodeURIComponent(data)+'&acctbookid='+acctbookid,
			waitMsg:'������...',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'������ӳɹ�! ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							// itemGridDs.load(({params:{start:0,limit:25}}));
							 itemGridDs.load({params:{start:0,limit:itemGridPagingToolbar.pageSize,acctbookid:acctbookid}});
									
				}else
				{
					var message="";
					if(jsonData.info=='RepCode') message='������ı����Ѵ���,����������! ';
					if(jsonData.info=='RepName') message='������������Ѵ���,����������! ';
					//if(jsonData.info=='mistake0') message='��Ŀ���볤���뼶��Ҫ��ƥ��! ';
					if(jsonData.info=='mistake1') message='��˶Ը������ݵ��ϼ���Ŀ�Ƿ����! ';
					if(jsonData.info=='mistake2') message='���ʧ�ܣ��ϼ���ĿΪĩ����Ŀ! ';
					if(jsonData.info=='mistake3') message='���ʧ�ܣ���˶���Ŀ�����Ƿ���ȷ! ';
					Ext.Msg.show({title:'��ʾ',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				}
			},
			scope: this
		});
	};
	//addwin.close();
	
	}	
			//***��Ӽ����¼�***//	
	addButton.addListener('click',addHandler,true);

	cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��',
		iconCls:'back'
	});
	
	cancelHandler = function(){
		addwin.close();
	}
	
	cancelButton.addListener('click',cancelHandler,false);

	//***����һ������***//
	addwin = new Ext.Window({
		title: '&nbsp;&nbsp;&nbsp;&nbsp;�ֽ�������Ŀ��Ӵ���',
		width: 470,
		height: 360,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:10px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			addButton,
			cancelButton
		]
	});		
	addwin.show();
	
	
		
}


