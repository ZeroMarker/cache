var userid = session['LOGON.USERID'];
var projUrl='../csp/herp.acct.acctcashflowitemmainexe.csp';			
funedit = function() {
	
	var rowObj = itemGrid.getSelectionModel().getSelections(); 
	 
    var rowid=rowObj[0].get("rowid");
	
	
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
			blankText :"��ѡ�����Ŀ����Ŀ����",
			store : CIlevelDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			emptyText:'��ѡ����Ŀ����',
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
						CINameField.focus();
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
									IsStopField.focus();
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
			allowBlank : false,
			blankText :"��ѡ�����Ŀ�Ƿ�ͣ��",
			store : IsStopFieldDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			emptyText:'��ѡ���Ƿ�ͣ��',
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
			selectOnFocus : true,
			allowBlank : false,
			blankText :"��ѡ�����Ŀ�Ƿ�Ϊĩ��",
			store : IsLastFieldDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // ����ģʽ
			editable : false,
			emptyText:'��ѡ���Ƿ�ĩ��',
			selectOnFocus : true,
			forceSelection : true,
			listeners:{
					select:function(){
					var last=IsLastField.getValue();
					if(last==1) {MoneyFlowField.enable();}
					else {MoneyFlowField.disable();
					 
					}
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
              }); //����Ǳ�Ҫ��  eSJFieldSet 
	

	var eSJFieldSet = new Ext.form.FieldSet({
		//title : '�ֽ�������Ŀά��',
		height : 275,
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
					CINameField,        
					CICodeField,
					SupNumberField,
					IsStopField,   
					IsLastField,     
					MoneyFlowField					
					]	
		}
		]
	});



//***����ṹ***//
	var colItems =	[{
		layout: 'column',
		//border: true,
		defaults: {
			columnWidth: '1.0',
			bodyStyle:'padding:2px 3px 0px',
			border: false
			},            
		items:[{
			xtype: 'fieldset',
			autoHeight: true,
			items:[
				eSJFieldSet	
			]
		}]
	}];
	
	//***�������(���)***//
	var formPanel = new Ext.form.FormPanel({
		labelWidth: 70,
		frame: true,
		items: colItems
	});
	
	var level  =  CIlevelfield.getValue();   //��Ŀ����
	var name   =  CINameField.getValue();    //��Ŀ����
	var code   =  CICodeField.getValue();    //��Ŀ����
	var supers =  SupNumberField.getValue(); //�ϼ�����
	
	//var isStop = (IsStopField.getValue() == true) ? '1' : '0'; //�Ƿ�ͣ��
	//var islast = (IsLastField.getValue() == true) ? '1' : '0'; //�Ƿ�ĩ��
	var isStop =  IsStopField.getValue();   //�Ƿ�ͣ��
	var islast =  IsLastField.getValue();   //�Ƿ�ĩ��
	var direct =  MoneyFlowField.getValue();  //��������
	var spell  =  CISpellField.getValue();    //ƴ����
    
    if((name=="")||(code==""))
	{
		Ext.Msg.show({title:'��ʾ',msg:'��������Ʋ���Ϊ��! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	};
	
			

    
    
    //��ֵ
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			CICodeField.setValue(rowObj[0].get("ItemCode"));
			var SubjNames=rowObj[0].get("ItemName");
			var SubjNames=SubjNames.split(";");
            SubjName = SubjNames[SubjNames.length-1];
			CINameField.setValue(SubjName);
			//CINameField.setValue(rowObj[0].get("ItemName"));			
			SupNumberField.setValue(rowObj[0].get("supers"));
			var level=rowObj[0].get("Cilevel")
			CIlevelfield.setValue(level);
			var eIsLast=rowObj[0].get("isLast");
			if(eIsLast=="��"){
				IsLastField.setValue(1);
			}else{
				IsLastField.setValue(0);
			};
			
			var edirection=rowObj[0].get("cfdirection");
			if(edirection=="����"){
				MoneyFlowField.setValue(1);
			}
			else if(edirection=="����"){
				MoneyFlowField.setValue(0);
			}
			else{
			   MoneyFlowField.disable();
			 		
			}
			
			var eIsStop=rowObj[0].get("isStop");
			if(eIsStop=="��"){
				IsStopField.setValue(1);
			}else{
				IsStopField.setValue(0);
			};
			
		});
	
	//***ȷ����ť***//
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
	
	//var isStop = (IsStopField.getValue() == true) ? '1' : '0';    //�Ƿ�ͣ��
	//var islast = (IsLastField.getValue() == true) ? '1' : '0';    //�Ƿ�ĩ��
	var isStop =  IsStopField.getValue();    //�Ƿ�ͣ��
	var islast =  IsLastField.getValue();    //�Ƿ�ĩ��
	var direct =  MoneyFlowField.getValue(); //��������
	var spell  =  CISpellField.getValue();   //ƴ����
	

	
	
	/*var len3=0;
	var flag=1;
	Ext.Ajax.request({
		    async: false,
			url: '../csp/herp.acct.acctcashflowitemmainexe.csp?action=editLength&acctbookid='+acctbookid+'&level='+level,
			waitMsg:'������...',
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					 len3= jsonData.info;
					// alert(len3+'len3');
					 var len4  = code.length;
					 //alert(len3+'^'+len4);
					if(len4!=len3){
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
			url: '../csp/herp.acct.acctcashflowitemmainexe.csp?action=edit&data='+encodeURIComponent(data) + '&acctbookid=' + acctbookid+ '&rowid='+rowid,
			waitMsg:'������...',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					{Ext.Msg.show({title:'ע��',msg:'�����޸ĳɹ�! ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							 itemGridDs.load({params:{start:0,limit:itemGridPagingToolbar.pageSize,acctbookid:acctbookid}});
					}		
				    addwin.close();
				}else
				{
					var message="";
					if(jsonData.info=='RepCode') message='�ñ����Ѵ���,������������! ';
					if(jsonData.info=='RepName') message='�������Ѵ���,������������! ';
					//if(jsonData.info=='err1') message='����Ŀ���볤���뼶��Ҫ��ƥ��! ';
					if(jsonData.info=='err2') message='��˶Ը������ݵ��ϼ���Ŀ�Ƿ����! ';
					if(jsonData.info=='err3') message='�޸�ʧ�ܣ��ϼ���ĿΪĩ����Ŀ! ';
					if(jsonData.info=='err4') message='�޸�ʧ�ܣ�����Ŀ�����Ӽ���Ŀ! ';
					if(jsonData.info=='err5') message='�޸�ʧ�ܣ���˶���Ŀ�����Ƿ���ȷ! ';
					//if(jsonData.info=='err6') message='�޸�ʧ�ܣ�����ĿΪһ����Ŀ���ϼ��������! ';
					Ext.Msg.show({title:'��ʾ',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				}
			},
			scope: this
		});
	//}
	//addwin.close();
	
	}
}	
			//***��Ӽ����¼�***//	
	addButton.addListener('click',addHandler,false);

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
		title: '&nbsp;&nbsp;&nbsp;&nbsp;�ֽ�������Ŀ�޸Ĵ���',
		width: 470,
		height:380,
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


