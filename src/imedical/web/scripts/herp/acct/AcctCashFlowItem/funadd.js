var userid = session['LOGON.USERID'];	
var projUrl='../csp/herp.acct.acctcashflowitemmainexe.csp';	


funadd = function() {	
	
	//项目级别
	var CIlevelDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [
				['1','1级'],['2','2级'],['3','3级'],['4','4级'],
				['5','5级'],['6','6级'],['7','7级'],['8','8级']
			]
		});
		var CIlevelfield= new Ext.form.ComboBox({
			id : 'CIlevelfield',
			fieldLabel : '项目级别',
			width : 230,
			selectOnFocus : true,
			allowBlank : false,
			//value : 1,
			blankText :"请选择该项目的项目级别",
			store : CIlevelDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // 本地模式
			editable : false,
			emptyText:'请选择项目级别...',
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


	
	//项目编码 
	var CICodeField = new Ext.form.TextField({
		fieldLabel: '项目编码',
		width:230,
		allowBlank : false,  
		blankText :"请录入该项目的项目编码",
		selectOnFocus:'true',
		regex :/(^[A-Za-z0-9]+$)/,
		emptyText:'请录入项目编码...',
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
							title : '提示',
							msg : '请录入该项目的项目编码 ',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING,
							fn : Handler
						});
					}
				}
			}
		}
	});
	
	
	//项目名称 
	var CINameField = new Ext.form.TextArea({
		fieldLabel: '项目名称',
		width:230,
		//height:'auto', 
		height:40, 
		style:'overflow:hidden',
		allowBlank : false,
		blankText :"请录入该项目的项目名称",
		emptyText:'请录入项目名称...', 
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
							title : '提示',
							msg : '请录入该项目的项目名称 ',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING,
							fn : Handler
						});
					}
				}
			}
		}
	});
	

 //上级编码  
	    	var SupNumberField = new Ext.form.TextField({
						id: 'SupNumberField',
						fieldLabel: '上级编码',
						width:230,
						allowBlank : false,  
						blankText :"请录入该项目的上级编码",
						selectOnFocus:'true',
						regex :/(^[A-Za-z0-9]+$)/,
						emptyText:'请录入上级编码...',
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
							title : '提示',
							msg : '请录入该项目的上级编码 ',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING,
							fn : Handler
						});
					}
				}
			}
		}
					});	
	
	
	
	//是否停用 
	
		var IsStopFieldDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '是'], ['0', '否']]
		});
		var IsStopField = new Ext.form.ComboBox({
			id : 'IsStopField',
			fieldLabel : '是否停用',
			width:230, 
			selectOnFocus : true,
			value :0,
			allowBlank : false,
			blankText :"请选择该项目是否停用",
			store : IsStopFieldDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // 本地模式
			editable : false,
			emptyText:'请选择是否停用...',
			selectOnFocus : true,
			forceSelection : true
		});	
		
		
		//是否末级
	var IsLastFieldDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '是'], ['0', '否']]
		});
		var IsLastField = new Ext.form.ComboBox({
			id : 'IsLastField',
			fieldLabel : '是否末级',
			width:230, 
			value : 1,
			selectOnFocus : true,
			allowBlank : false,
			blankText :"请选择该项目是否为末级",
			store : IsLastFieldDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // 本地模式
			editable : false,
			emptyText:'请选择是否末级...',
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
			
			
	           ////流量方向   
		var MoneyFlowDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '流入'], ['1', '流出']]
		});
	
		var MoneyFlowField = new Ext.form.ComboBox({
			    id : 'MoneyFlowField',
				fieldLabel : '流量方向',
				width : 230,
				allowBlank : false,
				value : 0,
				blankText :"请选择该项目的流量方向",
				store : MoneyFlowDs,		
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '请选择流量方向...',
				mode : 'local', // 本地模式
				editable : false,
				//value:1,
				selectOnFocus : true,
				forceSelection : true
				// disabled:true
		});	
			
		var CISpellField = new Ext.form.TextField({
				fieldLabel: '拼音码',
				width:230,
				allowBlank : true,	
				emptyText : '可自动生成...',
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
              }); //这段是必要的  
		
		
	
    
	
		var SJFieldSet = new Ext.form.FieldSet({
		//title : '现金流量项目维护',
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


//***定义结构***// 
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
	
	//***加载面板(框架)***//
	var formPanel = new Ext.form.FormPanel({
		labelWidth: 70,
		frame: true,
		items: colItems
	});
	
	//***添加按钮***//
	addButton = new Ext.Toolbar.Button({
		text:'保存',
		iconCls:'save'
	});


	//////////////////////////  增加按钮响应函数   //////////////////////////////
	addHandler = function(){ 
	var level  =  CIlevelfield.getValue();   //项目级别
	var name   =  CINameField.getValue();    //项目名称
	var code   =  CICodeField.getValue();    //项目编码
	var supers =  SupNumberField.getValue(); //上级编码
	var isStop = IsStopField.getValue();
	var islast = IsLastField.getValue();
	var direct = MoneyFlowField.getValue();
	// var isStop = (IsStopField.getValue() == true) ? '1' : '0';    //是否停用
	// var islast = (IsLastField.getValue() == true) ? '1' : '0';    //是否末级
	// var direct = (MoneyFlowField.getValue() == true) ? '1' : '0'; //流量方向
	var spell  =  CISpellField.getValue();    //拼音码
	
if((name=="")||(code==""))
	{
		Ext.Msg.show({title:'提示',msg:'编码或名称不能为空! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	};
/*if(isStop=="")
	{
		Ext.Msg.show({title:'提示',msg:'请选择该项目是否停用',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	};*/
if(islast=="")
	{
		Ext.Msg.show({title:'提示',msg:'请选择该项目是否为末级! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	};		

	
   /* var len2=0;
	var flag=1;
	Ext.Ajax.request({
		    async: false,
			url: '../csp/herp.acct.acctcashflowitemmainexe.csp?action=GetLength&acctbookid='+acctbookid+'&level='+level,
			waitMsg:'保存中...',
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					 len2= jsonData.info;
					 var len  = code.length;
					if(len!=len2){
					Ext.Msg.show({title:'错误',msg:'科目编码不规范',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
			waitMsg:'保存中...',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'数据添加成功! ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							// itemGridDs.load(({params:{start:0,limit:25}}));
							 itemGridDs.load({params:{start:0,limit:itemGridPagingToolbar.pageSize,acctbookid:acctbookid}});
									
				}else
				{
					var message="";
					if(jsonData.info=='RepCode') message='您输入的编码已存在,请重新输入! ';
					if(jsonData.info=='RepName') message='您输入的名称已存在,请重新输入! ';
					//if(jsonData.info=='mistake0') message='项目编码长度与级别要求不匹配! ';
					if(jsonData.info=='mistake1') message='请核对该条数据的上级项目是否存在! ';
					if(jsonData.info=='mistake2') message='添加失败，上级项目为末级项目! ';
					if(jsonData.info=='mistake3') message='添加失败，请核对项目级别是否正确! ';
					Ext.Msg.show({title:'提示',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				}
			},
			scope: this
		});
	};
	//addwin.close();
	
	}	
			//***添加监听事件***//	
	addButton.addListener('click',addHandler,true);

	cancelButton = new Ext.Toolbar.Button({
		text:'取消',
		iconCls:'back'
	});
	
	cancelHandler = function(){
		addwin.close();
	}
	
	cancelButton.addListener('click',cancelHandler,false);

	//***定义一个窗口***//
	addwin = new Ext.Window({
		title: '&nbsp;&nbsp;&nbsp;&nbsp;现金流量项目添加窗口',
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


