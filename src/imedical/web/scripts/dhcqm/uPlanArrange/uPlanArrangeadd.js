var QMSchemF;
var QMSchemFl;
var namef;
 
sysorgaffiaddFun = function(store,itemGridPagingToolbar) {
	
var getFullPeriodType = function (date) {
  var d = date.getMonth()+1;
  
  var m= Math.floor( ( d% 3 == 0 ? ( d/ 3 ) : ( d / 3 + 1 ) ) );
 return "0"+m;
  
}


var periodYear = new Ext.form.TextField({
	id: 'periodYear',
	fieldLabel: '年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;度',
	anchor: '95%',
	listWidth : 213,
	triggerAction: 'all',
	emptyText:'请输入四位数字的年份',
	regex:/^\d{4}$/,
	regexText:'请输入有效的年份',
	value:(new Date()).getFullYear(),
	name: 'periodYear',
	minChars: 1,
	pageSize: 10,
	editable:false
});

var dataStr="";

var data="";
var data1=[['01','01月份'],['02','02月份'],['03','03月份'],['04','04月份'],['05','05月份'],['06','06月份'],['07','07月份'],['08','08月份'],['09','09月份'],['10','10月份'],['11','11月份'],['12','12月份']];
var data2=[['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']];

var count1=0;
var count2=0;

var monthStore="";



var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	anchor: '95%',
	//listWidth : 213,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	
	value:'Q',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true,
	listeners:{"select":function(combo,record,index){ 
		
	}}   
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	
	startperiodStore.loadData(data);
	
	
});

startperiodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
startperiodStore.loadData([['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']]);

var startperiodField = new Ext.form.ComboBox({
	id: 'startperiodField',
	fieldLabel: '期&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;间',
	value:getFullPeriodType(new Date()),
	anchor: '95%',
	//listWidth : 213,
	selectOnFocus: true,
	allowBlank: false,
	store: startperiodStore,
	
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'请选择...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var noname=new Ext.form.TextField({
	fieldLabel: '标&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;题',
	anchor: '95%',
	value:'绩效考核'
	})

var CheckStartDate1 = new Ext.form.DateField({
	id:'CheckStartDate1',
	//format:'Y-m-d',
	fieldLabel:'起始时间',
	anchor: '95%',
	disabled:false,
	emptyText: '请选择起始时间...',
	listeners :{
		specialKey :function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				if(startDate.getValue()!=""){
					endDate.focus();
				}else{
					Handler = function(){startDate.focus();}
					Ext.Msg.show({title:'提示',msg:'起始时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
				}
			}
		}
	}
});
		
//定义结束时间控件
var CheckEndDate1 = new Ext.form.DateField({
	id:'CheckEndDate1',
	//format:'Y-m-d',
	fieldLabel:'结束时间',
	anchor: '95%',
	disabled:false,
	emptyText: '请选择结束时间...',
	listeners :{
	specialKey :function(field,e){
		if (e.getKey() == Ext.EventObject.ENTER){
			if(endDate.getValue()!=""){
				
			}else{
				Handler = function(){endDate.focus();}
				Ext.Msg.show({title:'提示',msg:'结束时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
			}
		}
	}
}
});

var userDs = new Ext.data.Store({   //解析数据源
           autoLoad:true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'	
			},['grupRowid','grupName'])	
});

userDs.on('beforeload',function(ds,o){  //数据源监听函数调用后台类方法查询数据
    var periodType=periodTypeField.getValue();
	ds.proxy = new Ext.data.HttpProxy({
		url:'dhc.qm.uPlanArrangeexe.csp'+'?action=userList&str='+encodeURIComponent(Ext.getCmp('userField').getRawValue()),method:'POST'
	});	
});

var userField = new Ext.form.ComboBox({   //定义单位组合控件
            id: 'userField',
			fieldLabel: '检&nbsp;&nbsp;查&nbsp;&nbsp;人',
			anchor: '95%',
			//listWidth: 213,
			selectOnFocus: true	,
			store: userDs,
			displayField: 'grupName',
			valueField: 'grupRowid',
			triggerAction: 'all',
			emptyText: '请选择...',
			//typeAhead: true,
			forceSelection: true,
			minChars: 1,
			pageSize: 10,
			//selectOnFocus: true,
	        forceSelection: true		
});
var StartDate = new Ext.form.DateField({
			id:'StartDate',
			//format:'Y-m-d',
			fieldLabel:'任务开始日期',
			anchor: '95%',
			disabled:false,
			emptyText: '请选择开始时间...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(StartDate.getValue()!=""){
							
						}else{
							Handler = function(){endDate.focus();}
							Ext.Msg.show({title:'提示',msg:'开始时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
var EndDate = new Ext.form.DateField({
			id:'EndDate',
			//format:'Y-m-d',
			fieldLabel:'任务截止日期',
			anchor: '95%',
			disabled:false,
			emptyText: '请选择截止时间...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(endDate.getValue()!=""){
							
						}else{
							Handler = function(){endDate.focus();}
							Ext.Msg.show({title:'提示',msg:'截止时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
QMSchemField = new Ext.form.TextField({
				id:'QMSchemField',
				fieldLabel: '检查项目',
				allowBlank: true,
				anchor: '80%',
				emptyText:'请选择项目',
				editable:false,
				disabled:true,
				selectOnFocus:'true',
				itemCls:'sex-female', //向左浮动,处理控件横排
				clearCls:'allow-float' //允许两边浮动
				
			});	
	
/*var QMSchemButton = new Ext.Toolbar.Button({
		text: '编&nbsp;&nbsp;辑',
		handler: function(){QMSchem(itemGridDs,itemGrid,itemGridPagingToolbar,"add" );
		}
});
*/
 nameField = new Ext.form.TextField({
				id:'nameField',
				fieldLabel: '检查病区',
				allowBlank: true,
				anchor: '80%',
				emptyText:'请选择病区',
				editable:false,
				disabled:true,
				selectOnFocus:'true',
				itemCls:'sex-female', //向左浮动,处理控件横排
				clearCls:'allow-float' //允许两边浮动
				
			});	
/*	
var nameButton = new Ext.Toolbar.Button({
		text: '编&nbsp;&nbsp;辑',
		handler: function(){
			//获得年度，期间类型和期间的值
			var CycleDr=periodYear.getValue();
			var periodType=periodTypeField.getValue()=="Q"?"季":"月";
			var period=startperiodField.getValue();
			var user = userField.getValue();
			
			//alert(CycleDr+"  "+yearVal.test(CycleDr));
			//设置传参
			var periodtxt=CycleDr+"年"+period+periodType;
			var yearPeriod=CycleDr+period;
			var yearVal=/^\d{4}$/;
			if(!yearVal.test(CycleDr)){
			
				Ext.Msg.show({title:'提示',msg:"请输入有效的年度!",buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;

			}else{
				Name(itemGridDs,itemGrid,itemGridPagingToolbar,"add",periodtxt,yearPeriod,user,"");
			}
		}
});
*/

QMSchemButtonFun =  function(){QMSchem(itemGridDs,itemGrid,itemGridPagingToolbar,"add" );
		};
nameButtonFun = function(){
			//获得年度，期间类型和期间的值
			var CycleDr=periodYear.getValue();
			var periodType=periodTypeField.getValue()=="Q"?"季":"月";
			var period=startperiodField.getValue();
			var user = userField.getValue();
			
			//alert(CycleDr+"  "+yearVal.test(CycleDr));
			//设置传参
			var periodtxt=CycleDr+"年"+period+periodType;
			var yearPeriod=CycleDr+period;
			var yearVal=/^\d{4}$/;
			if(!yearVal.test(CycleDr)){
			
				Ext.Msg.show({title:'提示',msg:"请输入有效的年度!",buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;

			}else{
				Name(itemGridDs,itemGrid,itemGridPagingToolbar,"add",periodtxt,yearPeriod,user,"");
			}
		};
//获取人员姓名

	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 90,
			items : [periodYear,periodTypeField,startperiodField,noname,CheckStartDate1,CheckEndDate1, userField,StartDate,EndDate,QMSchemField,nameField]
		});
	 var formLayCount=0
	 formPanel.on('afterlayout', function(panel, layout) { 
			if(formLayCount==0){
				$("input#QMSchemField").after('<button  type="button" onclick="QMSchemButtonFun()">编&nbsp;&nbsp;辑</button>');
				$("input#nameField").after('<button  type="button" onclick="nameButtonFun()">编&nbsp;&nbsp;辑</button>');

				formLayCount++;
			}
			
	 }); 
	var addWin = new Ext.Window({    
		title : '新建',
		width : 400,
		height : 400,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{		 
			text : '保存',
			handler : function() {
			if (formPanel.form.isValid()) {
					var CycleDr=periodYear.getValue();
					var period=periodYear.getValue()+startperiodField.getValue();
					var title=periodYear.getValue()+encodeURIComponent('年')+startperiodField.getValue()+encodeURIComponent((periodTypeField.getValue()=='Q'?'季度':'月份'))+encodeURIComponent(noname.getValue());
					var CheckStartDate1 = Ext.getCmp('CheckStartDate1').getValue();
				
					if(CheckStartDate1!=""){
						CheckStartDate1 = CheckStartDate1.format('Y-m-d');
					}else{
						Ext.Msg.show({title:'提示',msg:'开始日期为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					var CheckEndDate1 = Ext.getCmp('CheckEndDate1').getValue();
					if(CheckEndDate1!=""){
						CheckEndDate1 = CheckEndDate1.format('Y-m-d');
					}else{
						Ext.Msg.show({title:'提示',msg:'结束日期为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(checkDate(CheckStartDate1,CheckEndDate1)){
						
					}else{
						Ext.Msg.show({title:'提示',msg:'开始日期大于结束日期',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					
					var user = userField.getValue();
					if(user!=""){
						
					}else{
						Ext.Msg.show({title:'提示',msg:'检查人为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					var StartDate = Ext.getCmp('StartDate').getValue();
					if(StartDate!=""){
						StartDate = StartDate.format('Y-m-d');
					}else{
						Ext.Msg.show({title:'提示',msg:'开始日期为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					var EndDate = Ext.getCmp('EndDate').getValue();
					if(EndDate!=""){
						EndDate = EndDate.format('Y-m-d');
					}else{
						Ext.Msg.show({title:'提示',msg:'截止日期为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(checkDate(StartDate,EndDate)){
						
					}else{
						Ext.Msg.show({title:'提示',msg:'任务开始日期大于截止日期',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					var QMSchem = QMSchemF.trim();
					var  name = namef.trim();
				
					Ext.Ajax.request({
						url:'dhc.qm.uPlanArrangeexe.csp?action=add&title='+title+'&CycleDr='+CycleDr+'&period='+period+'&CheckStartDate1='+CheckStartDate1+'&CheckEndDate1='+CheckEndDate1+'&user='+user+'&StartDate='+StartDate+'&EndDate='+EndDate+'&QMSchem='+QMSchem+'&name='+name,
						
						waitMsg:'保存中...',
						failure: function(result,request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
													console.log(result.responseText);
							if (jsonData.success=='true'){				
									Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
									itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								}
								else
								{
									var message="重复添加";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this			
					  });
			  addWin.close();
			} 
			}					
		},
		{
			text : '关闭',
			handler : function() {
				addWin.close();
			}
		}]
	});
		addWin.show();
	};