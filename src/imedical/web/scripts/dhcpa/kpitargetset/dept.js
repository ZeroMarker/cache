function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};

var cycleIdCookieNameOfKPIDS="cycleDr";
var schemIdCookieNameOfKPIDS="schemDr";
var deptIdCookieNameOfKPIDS="deptDr";
var nameStr=cycleIdCookieNameOfKPIDS+"^"+schemIdCookieNameOfKPIDS+"^"+deptIdCookieNameOfKPIDS;
var dataStr="";
var count1=0;
var count2=0;
var count3=0;


var CycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

CycleDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('CycleField').getRawValue()+'&active=Y',method:'POST'})
	
});

var CycleField = new Ext.form.ComboBox({
	id: 'CycleField',
	fieldLabel:'年度',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: CycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'CycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/* CycleDs.on('load', function(ds, o){
	CycleField.setValue(getCookie(cycleIdCookieNameOfKPIDS));
	count1=1;
});
 */
var SchemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency','shortCutFreQuency'])
});

SchemDs.on('beforeload', function(ds, o){	
	
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.disttargetexe.csp?action=schem&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('SchemField').getRawValue())+'&active=Y',method:'POST'})
});
var SchemField = new Ext.form.ComboBox({
	id: 'SchemField',
	fieldLabel: '当前方案',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: SchemDs,
	anchor: '90%',
	displayField:'shortCutFreQuency',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'选择当前方案...',
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

/* SchemDs.on('load', function(ds, o){
	SchemField.setValue(getCookie(schemIdCookieNameOfKPIDS));
	count2=1;
}); */

var dept1Ds = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitName','shortCut'])
});

dept1Ds.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.disttargetexe.csp?action=dept&schemDr='+Ext.getCmp('SchemField').getValue(),method:'POST'})
	
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '科室',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: dept1Ds,
	anchor: '90%',
	displayField: 'shortCut',
	valueField: 'jxUnitDr',
	triggerAction: 'all',
	emptyText:'选择科室...',
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

/* dept1Ds.on('load', function(ds, o){
	deptField.setValue(getCookie(deptIdCookieNameOfKPIDS));
	count3=1;
});
 */
SchemField.on("select",function(cmb,rec,id ){
    searchFun1(cmb.getValue());
});

function searchFun1(schemDr){
	deptField.setValue("");
	deptField.setRawValue("");
	//绩效单位
    dept1Ds.reload();
	
	/* if(getCookie(schemIdCookieNameOfKPIDS)==schemDr){
		setComboValueFromServer(deptField,deptIdCookieNameOfKPIDS);
	}else{
		dept1Ds.on('load', function(ds, o){
			deptField.setValue("");
		});
	} */
};
//==============================================================================================================================

//==============================================================================================================================
var vouchDetailST = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.pa.basedataviewexe.csp'}),
	reader: new Ext.data.JsonReader({
		root: 'rows',
	totalProperty: 'results'
	}),
	remoteSort: true
});

var autoHisOutMedCm = new Ext.grid.ColumnModel([]);

var find = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add'
})

var updateYearData = new Ext.Toolbar.Button({
	text: '更新年度目标',
    tooltip:'更新年度目标',        
    iconCls:'add'
})
var updateValueData = new Ext.Toolbar.Button({
	text: '目标值、最佳值、基准值',
    tooltip:'导入目标值、最佳值、基准值数据',        
    iconCls:'add',
	handler:function(){importExcel()}
})

var initField = new Ext.Toolbar.Button({
	text: '数据初始化',
    tooltip:'对数据初始化',        
    iconCls:'remove',
	handler:function(){init()}
})

var updateValue = new Ext.Toolbar.Button({
	text: '导入接口目标值',
    tooltip:'导入目标值',        
    iconCls:'add',
	handler:function(){
		var cycleDr=Ext.getCmp('CycleField').getValue();
		var schemDr=Ext.getCmp('SchemField').getValue();
		var deptDr=Ext.getCmp('deptField').getValue();

		settvalue(cycleDr,schemDr,deptDr)}
})


var distKPI = new Ext.Toolbar.Button({
	text: '指标分解',
    tooltip:'指标分解',        
    iconCls:'add'
})

var deptMain = new Ext.grid.EditorGridPanel({
	title:'★按科室',
	store:vouchDetailST,
	cm:autoHisOutMedCm,
	region:'center',
	autoScroll:true,
	clicksToEdit:1,
	trackMouseOver:true,
	stripeRows:true,
	loadMask:true,
	tbar:['年度:',CycleField,'-','考核方案:',SchemField,'-','科室:',deptField,'-',find,'-',initField,'-',updateValue,'-',updateValueData]  // 去掉了更新年度目标值、指标分解 updateYearData,'-',distKPI,'-',
});

vouchDetailST.load();
function nodeClicked(node){
}

var tree="";

init2=function(){

	Ext.Ajax.request({
		url:'../csp/dhc.pa.disttargetexe.csp?action=init&cycleDr='+Ext.getCmp('CycleField').getValue()+'&schemDr='+Ext.getCmp('SchemField').getValue()+'&userCode='+userCode,
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success=='true'){
				Ext.Msg.show({title:'提示',msg:'数据初始化完成!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
			}else{
				if(jsonData.info=='Copyed'){
					Ext.Msg.show({title:'提示',msg:'当前战略已经初始化!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='NoCurrRecord'){
					Ext.Msg.show({title:'提示',msg:'没有当前战略!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='RepCurrRecord'){
					Ext.Msg.show({title:'提示',msg:'多个当前战略!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false1'){
					Ext.Msg.show({title:'提示',msg:'当前战略方案初始化失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false2'){
					Ext.Msg.show({title:'提示',msg:'当前战略方案明细初始化失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false3'){
					Ext.Msg.show({title:'提示',msg:'当前战略加扣分法初始化失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false4'){
					Ext.Msg.show({title:'提示',msg:'当前战略区间法初始化失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='nullUnit'){
					Ext.Msg.show({title:'提示',msg:'该方案下没有科室',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
			
			}
		},
		scope: this
	});
}

init = function(){
	var cycleDr=Ext.getCmp('CycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var schemDr=Ext.getCmp('SchemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	Ext.MessageBox.confirm('提示','确实要初始化数据吗?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:'../csp/dhc.pa.disttargetexe.csp?action=judgeinit&schemDr='+Ext.getCmp('SchemField').getValue(),
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if(jsonData.info=='Copyed'){
							Ext.MessageBox.confirm('提示','当前战略已经初始化,要重新初始化吗?',
								function(btn) {
									if(btn == 'yes'){
										init2();
									}	
								}
							)
						}else if(jsonData.info=='NoCurrRecord'){
							Ext.Msg.show({title:'提示',msg:'没有当前战略,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}else if(jsonData.info=='RepCurrRecord'){
							Ext.Msg.show({title:'提示',msg:'多个当前战略,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}else{
							//进行了两次初始化提醒
							//Ext.MessageBox.confirm('提示','确实要初始化吗?',
							//function(btn) {
							//if(btn == 'yes'){
										init2();
							//	}	
							//	}
							//)
						}
					},
					scope: this
				});
			}
		}
	)
}


//查询按钮处理函数
finddept = function(){
	var cycleDr=Ext.getCmp('CycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var schemDr=Ext.getCmp('SchemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var deptDr=Ext.getCmp('deptField').getValue();
	if((deptDr=="")||(deptDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择科室!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	dataStr=cycleIdCookieNameOfKPIDS+"^"+cycleDr+"!"+schemIdCookieNameOfKPIDS+"^"+schemDr+"!"+deptIdCookieNameOfKPIDS+"^"+deptDr;
	setBathCookieValue(dataStr);
	Ext.Ajax.request({
		url:'dhc.pa.kpitargetsetexe.csp?action=getTitleInfo&cycleDr='+cycleDr+'&schemDr='+schemDr,
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var cmConfig = {}; 
			var jsonHeadList = jsonData.rows; 
			var columns=[]; 
			for(var i=0;i<jsonHeadList.length;i++){
				if((jsonHeadList[i].name=="jxUnitDr")||(jsonHeadList[i].name=="KPIDr")){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:0,sortable:false,align:'left',hidden:true};
				}else if(jsonHeadList[i].name=="KPIName"){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:180,sortable:false,align:'left'};
				}else if(jsonHeadList[i].name=="KPICode"){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:105,sortable:false,align:'left'};
				}else{
					cmConfig = {
						header:jsonHeadList[i].title,
						dataIndex:jsonHeadList[i].name, 
						width:60,
						sortable:false,
						//renderer:format,
						align:'right'
					};
				}
				columns.push(cmConfig);
			}
			
			deptMain.removeAll();
			
			LoaderHandler=function(){
				return new Ext.tree.TreeLoader({
					dataUrl:'../scripts/ext2/cost/report/test11.csp',
					clearOnLoad:true,
					uiProviders:{
						'col': Ext.tree.ColumnNodeUI
					}
				})
			}
			
			var loader=LoaderHandler();
				
			loader.on('beforeload', function(loader,node){
				var url="dhc.pa.kpitargetsetexe.csp?action=schemdetaillist";
				loader.dataUrl=url+"&parent="+node.id+'&schemDr='+schemDr+'&deptDr='+deptDr;
			});
			
			RootHandler=function(){
				return new Ext.tree.AsyncTreeNode({
					id:'roo',
					text:'指标管理',
					//layer:0,
					//draggable:false,
					expanded:false
				})
			}
			
			TreeHanler=function(){
				return new Ext.tree.ColumnTree({
					height:650,
					//width:900,
					rootVisible:true,
					autoScroll:true,
					containerScroll:true,
					columns:columns,
					loader:loader,
					root:RootHandler(),
					listeners:{click:{fn:nodeClicked}}
				})
			}
			
			tree=TreeHanler();
			deptMain.add(tree);
			deptMain.doLayout(); //关键
			
			/*
			//节点可编辑关键代码
			var teEditor = new Ext.tree.ColumnTreeEditor(tree,{
				completeOnEnter:true,
				autosize:true,
				ignoreNoChange:true,
				expanded:true,
				grow:true, 
				listeners:{
					specialkey:function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
						
							//var sm = tree.getSelectionModel();
							//var node = sm.getSelectedNode();
							//var colValue=node.attributes.leaf;
							var colsObj=tree.columns[index];
							var dataIndex=colsObj.dataIndex;
							
							//alert(dataIndex);
							
							
							//获取节点
							
							
							alert(this.editColIndex);
							
							//重新获取该单元格的值
							var newValue=teEditor.getValue();
							//var colsObj=detailReport.columns[i];
							//var dataIndex=colsObj.dataIndex;
							
							
							var cols=detailReport.columns;
							//操作列对象
							for(var i=0;i<cols.length;i++){
								//获取单列
								var colObj=detailReport.columns[i];
								
								
								//获取单列dataIndex
								var dataIndex=colObj.dataIndex;
								//获取该节点单列的原始值
								var colValue=node.attributes[dataIndex];
								//组合字符串
								var objStr=i+"^"+dataIndex+"^"+colValue;
							}
							
						}
					}
				}
			});
			*/
		},
		scope:this
	});
}

find.addListener('click',finddept,false);


//更新年度函数
updateyear = function(){
	var cycleDr=Ext.getCmp('CycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var schemDr=Ext.getCmp('SchemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var deptDr=Ext.getCmp('deptField').getValue();
	if((deptDr=="")||(deptDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	
	var sm = tree.getSelectionModel();
	var node=sm.getSelectedNode();
	if(node==null){
		Ext.Msg.show({title:'提示',msg:'请选择要设置年度目标的记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
		return false;
	}else{ 
		var yearDataField=new Ext.form.NumberField({
			id:'yearDataField',
			fieldLabel:'设置年度目标',
			width:200,
			allowBlank:false,
			blankText:'请填写年度目标',
			msTarget:'qtip'
		})
		
		var form = new Ext.form.FormPanel({
			height:100,
			width:300,
			frame:true,
			labelSeparator:':',
			labelWidth:80,
			labelAlign:'right',
			items:[
				yearDataField
			]
		});
		
		//初始化设置按钮
		setButton = new Ext.Toolbar.Button({
			text:'确定'
		});
		
		//定义设置按钮响应函数
		setHandler = function(){
			//获取KPI指标Dr
			var KPIDr=node.attributes.id;
			if((KPIDr=="")||(KPIDr=="null")){
				Ext.Msg.show({title:'注意',msg:'指标数据有误,请检查该记录来源!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:350});
				return false;
			}
			//获取年度目标数据
			var yearData=yearDataField.getValue();
			if(yearData==""){
				yearData=0;
			}
			
			Ext.Ajax.request({
				url: 'dhc.pa.kpitargetsetexe.csp?action=setyeardata&schemDr='+schemDr+'&kpiDr='+KPIDr+'&yearData='+yearData+'&deptDr='+deptDr+'&cycleDr='+cycleDr,
				waitMsg:'保存中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						win.close();
						Ext.Msg.show({title:'注意',msg:'年度目标设置成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:250});
						finddept();
					}else{
						if(jsonData.info=='NoDatas'){
							Ext.Msg.show({title:'提示',msg:'没有数据更新或设置!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
						}
					}
				},
				scope: this
			});
		}
			
	
		//添加设置按钮的监听事件
		setButton.addListener('click',setHandler,false);
		
		//初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
		
		//定义取消按钮的响应函数
		cancelHandler = function(){
			win.close();
		}
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//初始化窗口
		win = new Ext.Window({
			title: '设置年度数据窗口',
			width: 350,
			height:150,
			minWidth: 350, 
			minHeight: 150,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyBorder:false, 
			buttonAlign:'center',
			border:false, 
			items:form,
			buttons: [
				setButton,
				cancelButton
			]
		});
		
		//窗口显示
		win.show();
	}
}
updateYearData.addListener('click',updateyear,false);

//指标分解
dist = function(){
	var sm = tree.getSelectionModel();
	var node=sm.getSelectedNode();
	if(node==null){
		Ext.Msg.show({title:'提示',msg:'请选择要分解的指标记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
		return false;
	}else{
		if(node.attributes.leaf==false){
			Ext.Msg.show({title:'提示',msg:'非叶子节点不能执行指标分解!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
			return false;
		}else{
			//获取年度数据
			var yearData = node.attributes.month00;
			if(yearData==0){
				Ext.Msg.show({title:'提示',msg:'年度目标为0,不需要分解!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
				return false;
			}
			//获取分解方法
			var distMethodDr = node.attributes.distMethodDr;
//alert(distMethodDr);
			if(distMethodDr==""){
				Ext.Msg.show({title:'提示',msg:'指标分解方法为空,请先设置方法!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:350});
				return false;
			}
			if(distMethodDr==0){
				Ext.Msg.show({title:'提示',msg:'该指标分解方法为不分解,程序结束!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:350});
				return false;
			}
			var cycleDr=Ext.getCmp('CycleField').getValue();
			if((cycleDr=="")||(cycleDr=="null")){
				Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
				return false;
			}
			var schemDr=Ext.getCmp('SchemField').getValue();
			if((schemDr=="")||(schemDr=="null")){
				Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
				return false;
			}
			var deptDr=Ext.getCmp('deptField').getValue();
			if((deptDr=="")||(deptDr=="null")){
				Ext.Msg.show({title:'注意',msg:'请选择科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
				return false;
			}
			//获取KPI指标Dr
			var KPIDr=node.attributes.id;
			if((KPIDr=="")||(KPIDr=="null")){
				Ext.Msg.show({title:'注意',msg:'指标数据有误,请检查该记录来源!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:350});
				return false;
			}
			//获取方法
			Ext.Ajax.request({
				url: 'dhc.pa.kpitargetsetexe.csp?action=distkpi&schemDr='+schemDr+'&kpiDr='+KPIDr+'&yearData='+yearData+'&deptDr='+deptDr+'&cycleDr='+cycleDr+'&distMethodDr='+distMethodDr,
				waitMsg:'保存中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'指标分解成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:200});
						finddept();
					}else{
						if(jsonData.info=='false'){
							Ext.Msg.show({title:'提示',msg:'指标分解失败,数据被回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
						}
						if(jsonData.info=='NoCycleDr'){
							Ext.Msg.show({title:'提示',msg:'考核年份丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
						}
						if(jsonData.info=='NoSchemDr'){
							Ext.Msg.show({title:'提示',msg:'考核方案丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
						}
						if(jsonData.info=='NoKPIDr'){
							Ext.Msg.show({title:'提示',msg:'考核指标丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
						}
						if(jsonData.info=='NoDeptDr'){
							Ext.Msg.show({title:'提示',msg:'考核部门丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
						}
						if(jsonData.info=='NoYearData'){
							Ext.Msg.show({title:'提示',msg:'该指标没有缺少年度目标值!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
						}
						if(jsonData.info=='UnDistMethodDr'){
							Ext.Msg.show({title:'提示',msg:'该指标缺少指标分解方法!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
						}
						if(jsonData.info=='NoDatas'){
							Ext.Msg.show({title:'提示',msg:'没有你选择的组合条件的指标被分解!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:350});
						}
					}
				},
				scope: this
			});
		}
	}
}
distKPI.addListener('click',dist,false);

