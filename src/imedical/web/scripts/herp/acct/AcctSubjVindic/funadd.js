var userid = session['LOGON.USERID'];


addFun = function() {
			var uNameField = new Ext.form.TextField({
				fieldLabel: '��Ŀ����',
				width:180,
				allowBlank : false, 
				anchor: '95%',
                                //emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
                                        
					if(uNameField.getValue()!==""){
					uCodeField.focus();
						}else{
							Handler = function(){uNameField.focus();};
							Ext.Msg.show({title:'����',msg:'���Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
                                         	
						}
					}}
			});
			var uCodeField = new Ext.form.TextField({
				fieldLabel: '��Ŀ����',
				width:180,
				anchor: '95%',
				allowBlank : false, 
                                //emptyText: '��Ŀ����......', 
				selectOnFocus:'true',
				listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(uCodeField.getValue()!==""){
                                        Ext.Ajax.request({			          url: '../csp/herp.acct.acctsubjvindicmainexe.csp?action=getcoderule&userid='+userid,		
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var data = jsonData.info;
                                                        ///alert(data);
							var arr=data.split("-");
                            var j = uCodeField.getValue().length;
                                                        var i = 0;
                                                        var k = 0;
                                                        var count = 0;
                                                        ///alert(typeof(count));
                                                        for(;i<arr.length;i++)        ///�ж�����ı��볤���Ƿ����Ҫ��
                                                         {
                                                           arr[i]=parseInt(arr[i]);
                                                           count = count+arr[i];
                                                           ///alert(count);
                                                           if(count==j)
                                                            {
                                                             k = 1;
                                                             break;
                                                             }
                                                          }
                                                        if(k==1)                   ///�������Ҫ��ó���Ӧ�Ŀ�Ŀ����
                                                        {
                                                         Cellphonefield.setValue(i+1);
                                                         MnemField.focus();
                                                         if(i==0)
                                                         NumberField.disable();
                                                         else
                                                         NumberField.enable();
                                                         k=0;
                                                         }
						        else
                                                        {
                                                         alert("��Ŀ���벻���Ϲ淶!");
                                                   
                                                          uCodeField.focus();
                                                          Cellphonefield.setValue("");
                                                          uCodeField.setValue("");
                                                       
                                                         }
						}
					},
					scope: this
					});
									
								}else{
									
						Ext.Msg.show({title:'����',msg:'��Ŀ���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                                                Handler = function(){uCodeField.focus();};
                          
								}
									}
								}}
			});	
			var MnemField = new Ext.form.TextField({
				fieldLabel: '��Ŀȫ��',
				width:180,
				anchor: '95%',
				allowBlank : true,  
				selectOnFocus:'true',
				listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
                                                          if(Cellphonefield.getValue()==1)
                                                          EnglishName.focus();
                                                          else
                                                           NumberField.focus();
								}
								}}
			});




			var EnglishName = new Ext.form.TextField({
				fieldLabel: 'ƴ����',
				width:180,
				allowBlank : true,	
				anchor: '95%',
				selectOnFocus:'true',
                                regex :/(^[A-Za-z]+$)/,
				listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
                                                               
									familyname.focus();
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
              

	
		

                      //��ȡ�ϼ�����
		var superDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
			});
			
			
			superDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'herp.acct.acctsubjvindicmainexe.csp'+'?action=GetAcctSubj&str='+encodeURIComponent(Ext.getCmp('dCodeField').getRawValue

())+'&level='+encodeURIComponent(Ext.getCmp('Phone').getRawValue

()),method:'POST'});
			});
			


			var NumberField = new Ext.form.ComboBox({
				id : Number,
				fieldLabel: '�ϼ�����',
				width:180,
				listWidth : 300,
				allowBlank :true,
				store: superDs,
				valueField: 'code',
				displayField: 'name',
				triggerAction: 'all',
				//emptyText:'ѡ��...',
				name: 'NumberField',
				minChars: 1,
				pageSize: 10,
				anchor: '95%',
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
                                                                /*
								if(NumberField.getValue()!==""){
									EnglishName.focus();
								}else{
									Handler = function(){NumberField.focus();};
									Ext.Msg.show({title:'����',msg:'��Ų���Ϊ��!',buttons: 

									Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}*/
								EnglishName.focus();	
								}
								}}
			});	



			
		       //��ȡ�ƿ�Ŀ����ʶ
			var deptDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
			});
			
			
			deptDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'herp.acct.acctsubjvindicmainexe.csp'+'?action=GetSubjType&str='+encodeURIComponent(Ext.getCmp('dCodeField').getRawValue

					()),method:'POST'});
			});
			var dtTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '�ʲ���'], ['2', '��ծ��'], ['3', '���ʲ���'], ['4', '������'], ['5', '������']]
		});
			
			var dCodeField = new Ext.form.ComboBox({
				id: 'dCodeField',
				fieldLabel: '��Ŀ���',
				width:120,
				listWidth : 120,
				allowBlank: true,
				store: dtTypeStore,
				valueField: 'key',
				displayField: 'keyValue',
				triggerAction: 'all',
				//emptyText:'ѡ��...',
				name: 'dCodeField',
				minChars: 1,
				pageSize: 10,
				mode : 'local', // ����ģʽ
				anchor: '95%',
				selectOnFocus:true,
				forceSelection:'true',
				editable:true

			});
	
	        //��ȡ��Ŀ������ϵ
		var typeDs = new Ext.data.Store({
			//autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
		});
		
		
		typeDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
			url:'herp.acct.acctsubjvindicmainexe.csp'+'?action=GetSubjNature&str='+encodeURIComponent(Ext.getCmp('type1Field').getRawValue

()),method:'POST'});
		});
		
		var type1Field = new Ext.form.ComboBox({
			id: 'type1Field',
			fieldLabel: '��Ŀ����',
			width:120,
			listWidth : 140,
			allowBlank: true,
			anchor: '95%',
			store: typeDs,
			valueField: 'code',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'ѡ��...',
			name: 'type1Field',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(type1Field.getValue()!==""){
									stateField.focus();
								}else{
									Handler = function(){type1Field.focus();};
									Ext.Msg.show({title:'����',msg:'��Ŀ������ϵ����Ϊ��!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									
								}
								}}
		});
			
		
			//�Ƿ�ĩ��
                       
			var stateFieldStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��'], ['2', '��']]
			});
			var stateField = new Ext.form.ComboBox({
				id : 'stateField',
				fieldLabel : '�Ƿ�ĩ��',
				width : 200,
				selectOnFocus : true,
				allowBlank : false,
				store : stateFieldStore,
				anchor : '95%',			
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				//emptyText : 'ѡ��...',
				mode : 'local', // ����ģʽ
				editable : false,
				value:1,
				selectOnFocus : true,
				forceSelection : true,
				listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(stateField.getValue()!==""){
									Secgroup.focus();
								}else{
									Handler = function(){stateField.focus();};
									Ext.Msg.show({title:'����',msg:'�Ƿ�ĩ������Ϊ��!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									
								}
								}}
			});
			
                 ////�ֽ��־
                 var validFieldDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��'], ['0', '��']]
		});

		var validField = new Ext.form.ComboBox({
			 id : 'validField',
				fieldLabel : '�ֽ��־',
				width : 200,
				selectOnFocus : true,
				allowBlank : false,
				store : validFieldDs,
				anchor : '95%',			
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				//emptyText : 'ѡ��...',
				mode : 'local', // ����ģʽ
				editable : false,
				value:1,
				selectOnFocus : true,
				forceSelection : true,
			listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(HealthType.getValue()!==""){
									addButton.focus();
								}else{
									Handler = function(){validField.focus();};
									Ext.Msg.show({title:'����',msg:'�ֽ��־����Ϊ��!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									
								}
								}}
			});
 

	           ////����   
		var careDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '�跽'], ['-1', '����']]
		});
		
		
		var HealthType = new Ext.form.ComboBox({
			        id : 'HealthType',
				fieldLabel : '����',
				width : 200,
				selectOnFocus : true,
				allowBlank : false,
				store : careDs,
				anchor : '95%',			
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				//emptyText : 'ѡ��...',
				mode : 'local', // ����ģʽ
				editable : false,
				value:1,
				selectOnFocus : true,
				forceSelection : true,
			listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(HealthType.getValue()!==""){
									validField.focus();
								}else{
									Handler = function(){HealthType.focus();};
									Ext.Msg.show({title:'����',msg:'������Ϊ��!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									
								}
								}}
		});	

      ////�����־
		var groupDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '����'], ['0', '������']]
		});
		
		var Secgroup = new Ext.form.ComboBox({
			id: 'Secgroup',
			fieldLabel: '�����־',
			width : 200,
			selectOnFocus : true,
			allowBlank : true,
			store : groupDs,
			anchor : '95%',			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : 'ѡ��...',
			mode : 'local', // ����ģʽ
			editable : false,
			value:1,
			selectOnFocus : true,
			forceSelection : true,
			listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(Secgroup.getValue()!==""){
									HealthType.focus();
								}else{
									Handler = function(){Secgroup.focus();};
									Ext.Msg.show({title:'����',msg:'�����־����Ϊ��!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									
								}
								}}
		});
	

                     ///�Զ������
			var familyname = new Ext.form.TextField({
				fieldLabel: '�Զ������',
				width:180,
				allowBlank : true,	
				anchor: '95%',
			        //emptyText:'�Զ������......',
				selectOnFocus:'true',
				listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								
							        dCodeField.focus();
									
								}
								}}
			});

		
                       ///��Ŀ����
			var Cellphonefield = new Ext.form.NumberField({
						id: 'Phone',
						fieldLabel: '��Ŀ����',
						//minLength : 11,  
						//maxLength : 11, 
						//emptyText: '��Ŀ����......',
						anchor: '95%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									//Landlinefield.focus();
								}
							}
						}
					});

        //��ȡ������λ
		var unitDs = new Ext.data.Store({
			//autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
		});
		
		
		unitDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
			url:'herp.acct.acctsubjvindicmainexe.csp'+'?action=GetUnit&str='+encodeURIComponent(Ext.getCmp('type1Field').getRawValue

()),method:'POST'});
		});


var CountUnitField = new Ext.form.ComboBox({
			id: 'unitField',
			fieldLabel: '������λ',
			width:120,
			listWidth : 240,
			allowBlank :true,
			anchor: '95%',
			store: unitDs,
			valueField: 'code',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'ѡ��...',
			name: 'type1Field',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								if(type1Field.getValue()!==""){
									stateField.focus();
								}else{
									Handler = function(){type1Field.focus();};
									Ext.Msg.show({title:'����',msg:'��Ŀ������ϵ����Ϊ��!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									
								}
								}}
		});
     	var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.5',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
									uCodeField,
									uNameField,
									Cellphonefield,
									MnemField,
									NumberField,
									EnglishName,
									familyname								
								
								]	 
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
									dCodeField,
									type1Field,
									stateField,
									Secgroup,
									HealthType,			
									validField,
                                                                        CountUnitField
								]
							}]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 80,
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
			addButton = new Ext.Toolbar.Button({
				text:'���'
			});

			addHandler = function(){
			
			
				var name = uNameField.getValue(); //��Ŀ����
				var code = uCodeField.getValue(); //��Ŀ����
				var level = Cellphonefield.getValue(); //��Ŀ����
				var nameall = MnemField.getValue(); //��Ŀȫ��
				var supers = NumberField.getValue(); //�ϼ�����
				var spell = EnglishName.getValue(); //ƴ����
				var selcode = familyname.getValue(); //�Զ������
				var subje = dCodeField.getValue(); //��Ŀ����ʶ
				var nature = type1Field.getValue(); //��Ŀ������ϵ
				var islast = stateField.getValue(); //�Ƿ�ĩ��
				var couflag = Secgroup.getValue(); //�����־
				var direct = HealthType.getValue(); //����			
				var cash = validField.getValue(); //�ֽ��־
                                var CountUnit = CountUnitField.getValue(); //������λ
				var data = name + "|" + code + "|" + level + "|" + nameall + "|" + supers + "|" + spell + "|" + selcode + "|" + subje + "|" + nature + "|" +islast +"|" +couflag +"|" +direct +"|" +cash+"|"+CountUnit

				
				if(formPanel.form.isValid()){
			Ext.Ajax.request({
						url: '../csp/herp.acct.acctsubjvindicmainexe.csp?action=add&data='+encodeURIComponent(data) + '&userid=' + userid,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var apllycode = jsonData.info;
							Ext.Msg.show({title:'ע��',msg:'�û���Ϣ��ӳɹ����������Ⱥ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
									 itemGridDs.load({params:{start:0,limit:itemGridPagingToolbar.pageSize}});	
			if(sysids!==""){
			var arr=new Array();
			var len="";
			arr=sysids.split("^");
			len=arr.length;
			for(var i = 1; i < len; i++){
			var sysid = arr[i];
			var dataIndex='1,dataIndex'+sysid+'^&';
			var urll=dhcbaUrl+'/DataSync/Encrypt.html?'+'rowid='+1+'&Code='+uCode+'&dataIndex1='+dataIndex;	
  			//prompt("",urll)
  			Ext.Ajax.request({  
                url: urll,      
                method: "GET",  
                async: false,   //ASYNC �Ƿ��첽( TRUE �첽 , FALSE ͬ��)  
                params: { m: "GET",t: ""},  
                success: function(response, opts) {}, //����ɹ��Ļص�����   
                failure: function() { alert("��ȡĿ¼����ʧ�ܣ�"); }  // ����ʧ�ܵĻص�����  
            });		
            }	
			Ext.Ajax.request({
					url: 'dhc.sync.syncuserexe.csp?action=inserts&&data='+encodeURIComponent(data)+'&sysid='+sysids,
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						 if (jsonData.success=='true') {
						  Ext.Msg.show({title:'ע��',msg:'������ϵͳ�ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						  itemGrid.load({params:{start:0, limit:25}});
							window.close();
						}
						else{
						var message = "";
						message = "SQLErr: " + jsonData.info;
							if(jsonData.info=='fail') message='���浽��Ӧ����ʧ��!';
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								
						window.close();
						}
					},
					  	scope: this
				});
			}		
						
						}else
						{
							var message="";
							if(jsonData.info=='RepCode') message='����ı����Ѿ�����!';
							if(jsonData.info=='RepName') message='����������Ѿ�����!';
							if(jsonData.info=='RepEmail') message='����������Ѿ�����!';
							if(jsonData.info=='fail') message='���浽��Ӧ����ʧ��!';
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}
			
			addButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'ȡ��'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: '���ҳ��',
				width: 580,
				height: 340,
				//autoHeight: true,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					addButton,
					cancelButton
				]
			});		
			addwin.show();			
	
	}


