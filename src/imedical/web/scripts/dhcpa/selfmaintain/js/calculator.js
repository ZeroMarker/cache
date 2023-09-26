//编辑公式
formula = function(node,type){
	//type=1:表示添加操作
	//type=2:表示修改操作
	
	if(type==1){
		//用于显示
		globalStr = "";
		//表达式描述
		expreDesc = "";
		//用于退格
		globalStr2 = "";
		//用于存储
		globalStr3 = "";
		checkStr = "";
	}
	
	if(type==2){
		//用于显示
		globalStr = node.attributes.expName;
		//表达式描述
		expreDesc = node.attributes.expDesc;
		//用于退格
		globalStr2 = node.attributes.expName2;
		//用于存储
		globalStr3 = node.attributes.expression;
		
	}

	var area = new Ext.form.TextArea({
		id:'area',
		width:500,
		height:100,
		labelWidth:20,
		fieldLabel: '计算公式',
		readOnly:true
	});
	area.setValue(globalStr);
	var m = new Ext.form.TextField({
		id:'m',
		fieldLabel:'友情提示',
		allowBlank:true,
		width:700,
		emptyText:'请先清空表达式再编辑,以保证计算公式的准确性!',
		anchor:'90%',
		editable:false,
		readOnly:true,
		disabled:true
	});
	var expdesc = new Ext.form.TextField({
		id:'expdesc',
		fieldLabel:'公式描述',
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
		fieldLabel:'KPI 指标',
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
		title: '公式编辑区域',
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
		title: '公式编辑符号',
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
				tooltip:'点', 
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
				tooltip:'左大括弧', 
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
				tooltip:'右大括弧', 
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
				tooltip:'左中括弧', 
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
				tooltip:'右中括弧', 
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
				tooltip:'左小括弧', 
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
				tooltip:'右小括弧', 
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
				tooltip:'加号', 
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
				tooltip:'减号', 
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
				tooltip:'乘号', 
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
				tooltip:'除号', 
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
				tooltip:'指数', 
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
				tooltip:'回退', 
				handler:function(b){
					var arr = globalStr2.split("||");
					var substr=arr[arr.length-1]; //05月!5
					var sublength=substr.length; //6
					var substrarr=substr.split("!"); 
					var subsubstr=substrarr[0]; //05月
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
				tooltip:'清空', 
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


/**
var autohisoutmedvouchForm = new Ext.form.FormPanel({
		listWidth : 20,
		// title: '公式编辑符号',
		region : 'center',
		frame : true,
		height : 25,
		bodyStyle : 'padding:5 5 5 5',
		labelSeparator : ':',
		width : 550,
		items : [{
					xtype : 'panel',
					layout : "column",
					hideLabel : true,
					isFormField : true,
					items : [{
								columnWidth : .05,
								xtype : 'button',
								text : '9',
								tooltip : '9',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' '
											+ rec.get('rowid');
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '8',
								tooltip : '8',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '7',
								tooltip : '7',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '6',
								tooltip : '6',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '5',
								tooltip : '5',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '4',
								tooltip : '4',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '3',
								tooltip : '3',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '2',
								tooltip : '2',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '1',
								tooltip : '1',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '0',
								tooltip : '0',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '.',
								tooltip : '点',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '{',
								tooltip : '左大括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '}',
								tooltip : '右大括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '[',
								tooltip : '左中括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : ']',
								tooltip : '右中括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '(',
								tooltip : '左小括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : ')',
								tooltip : '右小括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '+',
								tooltip : '加号',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' ' + 'a' + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '-',
								tooltip : '减号',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '*',
								tooltip : '乘号',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '/',
								tooltip : '除号',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '^',
								tooltip : '指数',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .135,
								xtype : 'button',
								text : 'C',
								tooltip : '清空',
								handler : function(b) {
									globalStr = "";
									globalStr2 = "";
									checkStr = "";
									area.setValue(globalStr);
								}
							}]
				}]
	});
**/
	var OkButton = new Ext.Toolbar.Button({
		text:'确定',
		handler:function(){
				
			//alert(globalStr);
			//alert(globalStr2);
			//用于给全局变量globalStr3(用于存储)赋值
			var globalStr4="";
			
			//定义表达式
			var exp="";
			var arr = globalStr2.split("||");
			for(var i=0;i<arr.length;i++){
				var array = arr[i].split("!");
				if(array.length>1){
					//存储字符串
					var id="<"+array[1]+">";
					if(globalStr4==""){globalStr4 = id;}
					else{globalStr4 = globalStr4+""+id;}
					//表达式
					var ID=array[1];
					if(exp==""){exp=ID;}
					else{exp = exp+""+ID;}
				}else{
					//存储字符串
					if(globalStr4==""){globalStr4=arr[i];}
					else{globalStr4 = globalStr4+""+arr[i];}
					//验证表达式
					if(exp==""){exp=arr[i];}
					else{exp = exp+""+arr[i];}
				}
			}
			globalStr3 = globalStr4;
			
			//alert(exp);
			//处理字符串(转码处理)，判断公式的正确性
			//var exp=encodeURI(encodeURI(globalStr3));
			//var exp=Ext.urlEncode(globalStr3);
				
			//var uploadUrl = "http://127.0.0.1:8080/dhcpaverify/formulaverify";
			var uploadUrl = "http://172.26.253.41:8080/dhcba/formulaverify";
		
			//var exp = encodeURIComponent(Ext.encode(exp));
			
			var upUrl = uploadUrl+"?exp="+exp;
			//操作
			
			
					form.getForm().submit({
								url : upUrl,
								method : 'POST',
								waitMsg : '数据导入中, 请稍等...',
								success : function(form, action, o) {

							expreField.setValue(globalStr); //控件显示
							expreDescField.setValue(expdesc.getValue()); //描述控件显示
							
							win.close();

								},
								failure : function(form, action) {
									// Ext.MessageBox.alert("提示信息",

									if (jsonData.info == "failure") {
										Ext.Msg.show({
													title : '提示',
													msg : '计算操作符错误,请检查!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});

									}
									if (jsonData.info == "other") {
										Ext.Msg.show({
													title : '提示',
													msg : '表达式错误,请检查！',
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
				waitMsg:'保存中...',
				fileUpload : true,
				
				failure: function(response){
				
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					globalStr3="";
				},
				success: function(response){
		
					//var jsonData = Ext.util.JSON.decode(response.responseText);
					alert("1111");
					if(jsonData.info=="success"){
						m.setValue("表达式正确，可以保存！");
						
						var handler = function(){
							//alert(globalStr);
							expreField.setValue(globalStr); //控件显示
							expreDescField.setValue(expdesc.getValue()); //描述控件显示
							win.close();
						}
						Ext.Msg.show({title:'提示',msg:'表达式正确!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:handler,width:250});
					}if(jsonData.info=="failure"){
						m.setValue("计算操作符错误,请检查！");
						globalStr3="";
						return false;
					}if(jsonData.info=="other"){
						m.setValue("表达式错误,请检查！");
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
			text : '确定',
				handler : function() {

					var upUrl = dhcbaUrl + "/dhcba/formulaverify?exp="
							+ checkStr;

					var upUrl = dhcbaUrl + "/dhcba/formulaverify?exp="
							+ encodeURIComponent(checkStr);

					// prompt('upUrl', upUrl)

					formSet.getForm().submit({
								url : upUrl,
								method : 'POST',
								waitMsg : '数据导入中, 请稍等...',
								success : function(form, action, o) {

								expreField.setValue(globalStr); //控件显示
								expreDescField.setValue(expdesc.getValue()); //描述控件显示
								win.close();

								},
								failure : function(form, action) {
									// Ext.MessageBox.alert("提示信息",

									if (jsonData.info == "failure") {
										Ext.Msg.show({
													title : '提示',
													msg : '计算操作符错误,请检查!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});

									}
									if (jsonData.info == "other") {
										Ext.Msg.show({
													title : '提示',
													msg : '表达式错误,请检查！',
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
		text:'取消'
	});
	
	//定义取消修改按钮的响应函数
	cancelHandler = function(){
		win.close();
	}
	
	//添加取消按钮的监听事件
	cancelButton.addListener('click',cancelHandler,false);
		
	win = new Ext.Window({
		title: '指标公式编辑器',
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
	//窗口显示
	win.show();
}