var userid = session['LOGON.USERID'];
var projUrl='../csp/herp.acct.acctcashflowitemmainexe.csp';			
funedit = function() {
	
	var rowObj = itemGrid.getSelectionModel().getSelections(); 
	 
    var rowid=rowObj[0].get("rowid");
	
	
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
			blankText :"请选择该项目的项目级别",
			store : CIlevelDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // 本地模式
			editable : false,
			emptyText:'请选择项目级别',
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
						CINameField.focus();
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
									IsStopField.focus();
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
			allowBlank : false,
			blankText :"请选择该项目是否停用",
			store : IsStopFieldDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // 本地模式
			editable : false,
			emptyText:'请选择是否停用',
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
			selectOnFocus : true,
			allowBlank : false,
			blankText :"请选择该项目是否为末级",
			store : IsLastFieldDs,			
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			mode : 'local', // 本地模式
			editable : false,
			emptyText:'请选择是否末级',
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
              }); //这段是必要的  eSJFieldSet 
	

	var eSJFieldSet = new Ext.form.FieldSet({
		//title : '现金流量项目维护',
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



//***定义结构***//
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
	
	//***加载面板(框架)***//
	var formPanel = new Ext.form.FormPanel({
		labelWidth: 70,
		frame: true,
		items: colItems
	});
	
	var level  =  CIlevelfield.getValue();   //项目级别
	var name   =  CINameField.getValue();    //项目名称
	var code   =  CICodeField.getValue();    //项目编码
	var supers =  SupNumberField.getValue(); //上级编码
	
	//var isStop = (IsStopField.getValue() == true) ? '1' : '0'; //是否停用
	//var islast = (IsLastField.getValue() == true) ? '1' : '0'; //是否末级
	var isStop =  IsStopField.getValue();   //是否停用
	var islast =  IsLastField.getValue();   //是否末级
	var direct =  MoneyFlowField.getValue();  //流量方向
	var spell  =  CISpellField.getValue();    //拼音码
    
    if((name=="")||(code==""))
	{
		Ext.Msg.show({title:'提示',msg:'编码或名称不能为空! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	};
	
			

    
    
    //赋值
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
			if(eIsLast=="是"){
				IsLastField.setValue(1);
			}else{
				IsLastField.setValue(0);
			};
			
			var edirection=rowObj[0].get("cfdirection");
			if(edirection=="流出"){
				MoneyFlowField.setValue(1);
			}
			else if(edirection=="流入"){
				MoneyFlowField.setValue(0);
			}
			else{
			   MoneyFlowField.disable();
			 		
			}
			
			var eIsStop=rowObj[0].get("isStop");
			if(eIsStop=="是"){
				IsStopField.setValue(1);
			}else{
				IsStopField.setValue(0);
			};
			
		});
	
	//***确定按钮***//
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
	
	//var isStop = (IsStopField.getValue() == true) ? '1' : '0';    //是否停用
	//var islast = (IsLastField.getValue() == true) ? '1' : '0';    //是否末级
	var isStop =  IsStopField.getValue();    //是否停用
	var islast =  IsLastField.getValue();    //是否末级
	var direct =  MoneyFlowField.getValue(); //流量方向
	var spell  =  CISpellField.getValue();   //拼音码
	

	
	
	/*var len3=0;
	var flag=1;
	Ext.Ajax.request({
		    async: false,
			url: '../csp/herp.acct.acctcashflowitemmainexe.csp?action=editLength&acctbookid='+acctbookid+'&level='+level,
			waitMsg:'保存中...',
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					 len3= jsonData.info;
					// alert(len3+'len3');
					 var len4  = code.length;
					 //alert(len3+'^'+len4);
					if(len4!=len3){
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
			url: '../csp/herp.acct.acctcashflowitemmainexe.csp?action=edit&data='+encodeURIComponent(data) + '&acctbookid=' + acctbookid+ '&rowid='+rowid,
			waitMsg:'保存中...',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					{Ext.Msg.show({title:'注意',msg:'数据修改成功! ',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							 itemGridDs.load({params:{start:0,limit:itemGridPagingToolbar.pageSize,acctbookid:acctbookid}});
					}		
				    addwin.close();
				}else
				{
					var message="";
					if(jsonData.info=='RepCode') message='该编码已存在,请您重新输入! ';
					if(jsonData.info=='RepName') message='该名称已存在,请您重新输入! ';
					//if(jsonData.info=='err1') message='该项目编码长度与级别要求不匹配! ';
					if(jsonData.info=='err2') message='请核对该条数据的上级项目是否存在! ';
					if(jsonData.info=='err3') message='修改失败，上级项目为末级项目! ';
					if(jsonData.info=='err4') message='修改失败，该项目存在子级科目! ';
					if(jsonData.info=='err5') message='修改失败，请核对项目级别是否正确! ';
					//if(jsonData.info=='err6') message='修改失败，该项目为一级项目，上级编码错误! ';
					Ext.Msg.show({title:'提示',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				}
			},
			scope: this
		});
	//}
	//addwin.close();
	
	}
}	
			//***添加监听事件***//	
	addButton.addListener('click',addHandler,false);

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
		title: '&nbsp;&nbsp;&nbsp;&nbsp;现金流量项目修改窗口',
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


