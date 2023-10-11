var userid = session['LOGON.USERID'];


addFun = function() {
			var uNameField = new Ext.form.TextField({
				fieldLabel: '科目名称',
				width:180,
				allowBlank : false, 
				anchor: '95%',
                                //emptyText: '科目名称......',
				selectOnFocus:'true',
				listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
                                        
					if(uNameField.getValue()!==""){
					uCodeField.focus();
						}else{
							Handler = function(){uNameField.focus();};
							Ext.Msg.show({title:'错误',msg:'名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
                                         	
						}
					}}
			});
			var uCodeField = new Ext.form.TextField({
				fieldLabel: '科目编码',
				width:180,
				anchor: '95%',
				allowBlank : false, 
                                //emptyText: '科目名称......', 
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
                                                        for(;i<arr.length;i++)        ///判断输入的编码长度是否符合要求
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
                                                        if(k==1)                   ///如果符合要求得出相应的科目级别
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
                                                         alert("科目编码不符合规范!");
                                                   
                                                          uCodeField.focus();
                                                          Cellphonefield.setValue("");
                                                          uCodeField.setValue("");
                                                       
                                                         }
						}
					},
					scope: this
					});
									
								}else{
									
						Ext.Msg.show({title:'错误',msg:'科目编码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                                                Handler = function(){uCodeField.focus();};
                          
								}
									}
								}}
			});	
			var MnemField = new Ext.form.TextField({
				fieldLabel: '科目全称',
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
				fieldLabel: '拼音码',
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
              }); //这段是必要的  
              

	
		

                      //获取上级编码
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
				fieldLabel: '上级编码',
				width:180,
				listWidth : 300,
				allowBlank :true,
				store: superDs,
				valueField: 'code',
				displayField: 'name',
				triggerAction: 'all',
				//emptyText:'选择...',
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
									Ext.Msg.show({title:'错误',msg:'序号不能为空!',buttons: 

									Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}*/
								EnglishName.focus();	
								}
								}}
			});	



			
		       //获取科科目类别标识
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
			data : [['1', '资产类'], ['2', '负债类'], ['3', '净资产类'], ['4', '收入类'], ['5', '费用类']]
		});
			
			var dCodeField = new Ext.form.ComboBox({
				id: 'dCodeField',
				fieldLabel: '科目类别',
				width:120,
				listWidth : 120,
				allowBlank: true,
				store: dtTypeStore,
				valueField: 'key',
				displayField: 'keyValue',
				triggerAction: 'all',
				//emptyText:'选择...',
				name: 'dCodeField',
				minChars: 1,
				pageSize: 10,
				mode : 'local', // 本地模式
				anchor: '95%',
				selectOnFocus:true,
				forceSelection:'true',
				editable:true

			});
	
	        //获取科目性质体系
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
			fieldLabel: '科目性质',
			width:120,
			listWidth : 140,
			allowBlank: true,
			anchor: '95%',
			store: typeDs,
			valueField: 'code',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'选择...',
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
									Ext.Msg.show({title:'错误',msg:'科目性质体系不能为空!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									
								}
								}}
		});
			
		
			//是否末级
                       
			var stateFieldStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['2', '否']]
			});
			var stateField = new Ext.form.ComboBox({
				id : 'stateField',
				fieldLabel : '是否末级',
				width : 200,
				selectOnFocus : true,
				allowBlank : false,
				store : stateFieldStore,
				anchor : '95%',			
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				//emptyText : '选择...',
				mode : 'local', // 本地模式
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
									Ext.Msg.show({title:'错误',msg:'是否末级不能为空!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									
								}
								}}
			});
			
                 ////现金标志
                 var validFieldDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['0', '否']]
		});

		var validField = new Ext.form.ComboBox({
			 id : 'validField',
				fieldLabel : '现金标志',
				width : 200,
				selectOnFocus : true,
				allowBlank : false,
				store : validFieldDs,
				anchor : '95%',			
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				//emptyText : '选择...',
				mode : 'local', // 本地模式
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
									Ext.Msg.show({title:'错误',msg:'现金标志不能为空!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									
								}
								}}
			});
 

	           ////余额方向   
		var careDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '借方'], ['-1', '贷方']]
		});
		
		
		var HealthType = new Ext.form.ComboBox({
			        id : 'HealthType',
				fieldLabel : '余额方向',
				width : 200,
				selectOnFocus : true,
				allowBlank : false,
				store : careDs,
				anchor : '95%',			
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				//emptyText : '选择...',
				mode : 'local', // 本地模式
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
									Ext.Msg.show({title:'错误',msg:'余额方向不能为空!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									
								}
								}}
		});	

      ////核算标志
		var groupDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '核算'], ['0', '不核算']]
		});
		
		var Secgroup = new Ext.form.ComboBox({
			id: 'Secgroup',
			fieldLabel: '核算标志',
			width : 200,
			selectOnFocus : true,
			allowBlank : true,
			store : groupDs,
			anchor : '95%',			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '选择...',
			mode : 'local', // 本地模式
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
									Ext.Msg.show({title:'错误',msg:'核算标志不能为空!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
								}
									
								}
								}}
		});
	

                     ///自定义编码
			var familyname = new Ext.form.TextField({
				fieldLabel: '自定义编码',
				width:180,
				allowBlank : true,	
				anchor: '95%',
			        //emptyText:'自定义编码......',
				selectOnFocus:'true',
				listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								
							        dCodeField.focus();
									
								}
								}}
			});

		
                       ///科目级别
			var Cellphonefield = new Ext.form.NumberField({
						id: 'Phone',
						fieldLabel: '科目级别',
						//minLength : 11,  
						//maxLength : 11, 
						//emptyText: '科目级别......',
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

        //获取计量单位
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
			fieldLabel: '计量单位',
			width:120,
			listWidth : 240,
			allowBlank :true,
			anchor: '95%',
			store: unitDs,
			valueField: 'code',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'选择...',
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
									Ext.Msg.show({title:'错误',msg:'科目性质体系不能为空!',buttons: 

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
				text:'添加'
			});

			addHandler = function(){
			
			
				var name = uNameField.getValue(); //科目名称
				var code = uCodeField.getValue(); //科目编码
				var level = Cellphonefield.getValue(); //科目级别
				var nameall = MnemField.getValue(); //科目全称
				var supers = NumberField.getValue(); //上级编码
				var spell = EnglishName.getValue(); //拼音码
				var selcode = familyname.getValue(); //自定义编码
				var subje = dCodeField.getValue(); //科目类别标识
				var nature = type1Field.getValue(); //科目性质体系
				var islast = stateField.getValue(); //是否末级
				var couflag = Secgroup.getValue(); //核算标志
				var direct = HealthType.getValue(); //余额方向			
				var cash = validField.getValue(); //现金标志
                                var CountUnit = CountUnitField.getValue(); //计量单位
				var data = name + "|" + code + "|" + level + "|" + nameall + "|" + supers + "|" + spell + "|" + selcode + "|" + subje + "|" + nature + "|" +islast +"|" +couflag +"|" +direct +"|" +cash+"|"+CountUnit

				
				if(formPanel.form.isValid()){
			Ext.Ajax.request({
						url: '../csp/herp.acct.acctsubjvindicmainexe.csp?action=add&data='+encodeURIComponent(data) + '&userid=' + userid,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var apllycode = jsonData.info;
							Ext.Msg.show({title:'注意',msg:'用户信息添加成功，请稍作等候!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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
                async: false,   //ASYNC 是否异步( TRUE 异步 , FALSE 同步)  
                params: { m: "GET",t: ""},  
                success: function(response, opts) {}, //请求成功的回调函数   
                failure: function() { alert("获取目录请求失败！"); }  // 请求失败的回调函数  
            });		
            }	
			Ext.Ajax.request({
					url: 'dhc.sync.syncuserexe.csp?action=inserts&&data='+encodeURIComponent(data)+'&sysid='+sysids,
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						 if (jsonData.success=='true') {
						  Ext.Msg.show({title:'注意',msg:'保存在系统成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						  itemGrid.load({params:{start:0, limit:25}});
							window.close();
						}
						else{
						var message = "";
						message = "SQLErr: " + jsonData.info;
							if(jsonData.info=='fail') message='保存到相应的组失败!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								
						window.close();
						}
					},
					  	scope: this
				});
			}		
						
						}else
						{
							var message="";
							if(jsonData.info=='RepCode') message='输入的编码已经存在!';
							if(jsonData.info=='RepName') message='输入的名称已经存在!';
							if(jsonData.info=='RepEmail') message='输入的邮箱已经存在!';
							if(jsonData.info=='fail') message='保存到相应的组失败!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}
			
			addButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'取消'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: '添加页面',
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


