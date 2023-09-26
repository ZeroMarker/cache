//定义控件的全局变量

var data1=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
var data2=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
var data3=[['1','1~6上半年'],['2','7~12下半年']];
var data4=[['0','00']];
var count1=0;
var count2=0;
var count3=0;
var deptdr=session['LOGON.CTLOCID'];
var userCode = session['LOGON.USERCODE'];
var userdr = session['LOGON.USERID'];

//==========================================================
function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};

function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};
var getFullPeriodType = function (date) {
  var d = date.getMonth();
  d=d/3+1;
  return "0"+parseInt(d);

}
var yearField = new Ext.form.TextField({
	id: 'yearField',
	fieldLabel: '年份',
	width:50,
	regex: /^\d{4}$/,
	regexText:'年份为四位数字',
	listWidth :50,
	triggerAction: 'all',
	emptyText:'',
	name: 'yearField',
	value:(new Date()).getFullYear(),
	minChars: 1,
	pageSize: 10,
	editable:true
});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:60,
	listWidth :60,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	//anchor: '90%',
	value:'Q', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	//pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']];
	}
	if(cmb.getValue()=="Q"){
		data=[['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']];
	}
	if(cmb.getValue()=="H"){
		data=[['01','1~6上半年'],['02','7~12下半年']];
	}
	if(cmb.getValue()=="Y"){
		data=[['00','全年']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
periodStore.loadData([['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']]);
var PeriodField = new Ext.form.ComboBox({
	id: 'PeriodField',
	fieldLabel: '',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	value:getFullPeriodType(new Date()),
	//anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'请选择...',
	mode: 'local', //本地模式
	editable:false,
	//pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
///////////////////方案/////////////////////////////  
var SchemDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['schemDr','schemname'])
	});
					
SchemDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'dhc.pa.basicuintpacaluexe.csp'+'?action=listschems&str='+encodeURIComponent(Ext.getCmp('SchemCombox').getRawValue())+'&userCode='+userCode,method:'POST'});
	});
	
var SchemCombox = new Ext.form.ComboBox({
				    id :'SchemCombox',
				    fieldLabel: '方案',
				    width:200,
				    listWidth :200,
				     resizable:true,
				    allowBlank : false, 
				    store: SchemDs,
				    valueField: 'schemDr',
				    displayField: 'schemname',
				    triggerAction: 'all',
				    //emptyText:'选择...',
				    name: 'SchemCombox',
			    	minChars: 1,
				    pageSize: 10,
				    anchor: '95%',
				    selectOnFocus:true,
				    forceSelection:'true',
				    editable:true
			});
///////////////////状态/////////////////////////////  
var StateDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['0', '未提交'],['10', '审核未通过'], ['20', '已提交'], ['30', '审核通过'], ['60', '发布']]
	});		
		
var StateCombox = new Ext.form.ComboBox({
	                   id : 'StateCombox',
		           fieldLabel : '状态',
	                   width : 100,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : StateDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		          
		           selectOnFocus : true,
		           forceSelection : true
						  });	
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var year = yearField.getValue();
		var pattern=/^\d{4}$/;
        if(!pattern.test(year)){
			Ext.Msg.show({title:'注意',msg:'年份格式请输入四位有效数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
			return null;
		}

	    var periodtype = periodTypeField.getValue();
		var period = PeriodField.getValue();
	    var schemDr = SchemCombox.getValue();
		var state = StateCombox.getValue();
		itemGrid.load({params:{start:0,limit:25,year:year,periodType:periodtype,period:period,userCode:userCode,schemDr:schemDr,state:state}});
	}
});

//计算按钮
var CaluButton = new Ext.Toolbar.Button({
					text : '计算',
					iconCls : 'add',
					handler : function() {
						 Calufun();
				   }
  });
//提交按钮
var SubmitButton = new Ext.Toolbar.Button({
   	        text : '提交',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){
			    var  curstate=rowObj[i].get("auditstate");
				var procdesc = "";
				if (curstate=="审核未通过")
				{
				Ext.Msg.show({title:'错误',msg:'请先取消提交!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}else
			    if ((curstate=="已提交")||(curstate=="审核通过")||(curstate=="发布"))
				{
				Ext.Msg.show({title:'错误',msg:curstate+'不能提交!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			    else
				{
				   Ext.Ajax.request({
					//url:'dhc.pa.basicuintpacaluexe.csp'+'?action=submit&schemrowid='
					//+rowObj[i].get("schemrowid")
					//+'&sprrowid='+rowObj[i].get("sprrowid")+'&userid='+userdr+'&procdesc='+procdesc
					//+'&desc='+encodeURIComponent(rowObj[i].get("auditdesc")),
					url:'dhc.pa.basedeptpacheckexe.csp?action=check&rowid='
					+rowObj[i].get("sprrowid")+"&userdr="+userdr+"&schemedr="+rowObj[i].get("schemrowid")+"&result="+20+"&deptdr="
					+deptdr+"&desc="+encodeURIComponent(rowObj[i].get("auditdesc")),
		
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'注意',msg:'提交成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});								 itemGrid.load({params:{start:0, limit:25,userCode:userCode}});
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'错误',msg:'提交失败',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
				}
		     }
			}
		}
  });	
//取消提交按钮
var CancelSubmitButton = new Ext.Toolbar.Button({
   	        text : '取消提交',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要取消提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			for(var i = 0; i < len; i++){
			  var  curstate=rowObj[i].get("auditstate");
			  var procdesc="";
			  if (curstate=="已提交"||curstate=="审核未通过")
			  {
			     Ext.Ajax.request({
					//sprrowid url:'dhc.pa.basicuintpacaluexe.csp'+'?action=cancelsubmit&schemrowid='+rowObj[i].get("schemrowid")+'&sprrowid='+rowObj[i].get("sprrowid")+'&userid='+userdr+'&procdesc='+procdesc+'&desc='+encodeURIComponent(rowObj[i].get("auditdesc")),
					url:'dhc.pa.basedeptpacheckexe.csp?action=check&rowid='
					+rowObj[i].get("sprrowid")+"&userdr="+userdr+"&schemedr="+rowObj[i].get("schemrowid")+"&result="+0+"&deptdr="
					+deptdr+"&desc="+encodeURIComponent(rowObj[i].get("auditdesc")),
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'注意',msg:'取消提交成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});								itemGrid.load({params:{start:0, limit:25,userCode:userCode}});
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'错误',msg:'取消提交失败',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
			  }
			else{
			   Ext.Msg.show({title:'错误',msg:curstate+'不能进行取消提交!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
			   }
			}
		   }
		}
  });	 

//生成最终分数
var CopyScoreButton = new Ext.Toolbar.Button({
   	        text : '生成最终分',
			iconCls : 'option',
			handler : function() {
				
		    var year = yearField.getValue();
			var pattern=/^\d{4}$/;
       		if(!pattern.test(year)){
				Ext.Msg.show({title:'注意',msg:'年份格式请输入四位有效数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;
			}
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			var periodtype = periodTypeField.getValue();
			var period = PeriodField.getValue();
	    	//var schemDr = SchemCombox.getValue();
			var state = StateCombox.getValue();
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要生成最终分数的记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			for(var i = 0; i < len; i++){
			  var  curstate=rowObj[i].get("auditstate");
			  var procdesc="";
			  if (curstate=="未提交")
			  {
			     Ext.Ajax.request({
					url:'dhc.pa.basicuintpacaluexe.csp'+'?action=copyScore&schemDr='+rowObj[i].get("schemrowid")+'&year='+year+'&userCode='+userCode+'&period='+period+'&periodType='+periodtype,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'注意',msg:'生成最终分成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});								
								itemGrid.load({params:{start:0, limit:25,userCode:userCode}});
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'错误',msg:'生成最终分失败',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
			  }
			else{
			   Ext.Msg.show({title:'错误',msg:'该记录不能再进行生成最终分!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
			   }
			}
		   }
		}
  });	 

  
function renderTopic(value, p, record){
	//console.log(record);
	    return String.format(
	    		"<b><a target=\"_blank\" href=\""+dhcReportUrl+"/runqianReport/report/jsp/dhccpmrunqianreport.jsp?cycleDr={1}&frequency={2}&period={3}&schemDr={4}&groupDr={5}&report=HERPJXLocSumReportForOther.raq&reportName=HERPJXLocSumReportForOther.raq&ServerSideRedirect=dhccpmrunqianreport.csp\">{0}</a></b>",
	            value, record.data.yearid,record.data.checkperiodType,record.data.changedperiod,record.data.schemrowid,record.data.GroupDr);
}

var itemGrid = new dhc.herp.Grid({
		    title: '基层科室绩效考核计算',
		    region : 'north',
		    url: 'dhc.pa.basicuintpacaluexe.csp',
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {				
		                var record = grid.getStore().getAt(rowIndex);
						if ((record.data.auditstate== "未提交")||(record.data.auditstate== "已提交"))  
						{
						    if (columnIndex==15){
							  var cl1 = grid.getColumnModel().getIndexById("auditdesc");
							  grid.getColumnModel().setEditable(cl1,true);
		                      return true;
		                    } 
						}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
	                    var record = grid.getStore().getAt(rowIndex);
						if ((record.data.auditstate== "未提交")||(record.data.auditstate== "已提交")) 
						{
						    if (columnIndex==15){
							  var cl1 = grid.getColumnModel().getIndexById("auditdesc");
							  grid.getColumnModel().setEditable(cl1,true);
		                      return true;
		                    } 
						}
					   }
            },
			fields : [
			       new Ext.grid.CheckboxSelectionModel({hidden :false,editable:false
			       	
				     	
				      }),
			       {
						header : '方案ID',
						dataIndex : 'schemrowid',
						editable:false,
						hidden : true
					},  {
						header : '状态表ID',
						dataIndex : 'sprrowid',
						editable:false,
						hidden : true
					}, {
						id : 'yearid',
						header : '年度ID',
						align:'center',
						editable:false,
						width : 80,
						hidden : true,
						dataIndex : 'yearid'

					},{
						id : 'GroupDr',
						header : '科室分组ID',
						align:'center',
						editable:false,
						width : 80,
						hidden : true,
						dataIndex : 'GroupDr'

					},{
						id : 'checkperiodType',
						header : '核算期间ID',
						align:'center',
						editable:false,
						width : 80,
						hidden:true,
						dataIndex : 'checkperiodType'

					},{
						id : 'checkperiodTypeName',
						header : '核算期间',
						align:'center',
						editable:false,
						width : 80,
						dataIndex : 'checkperiodTypeName'

					},{
						id : 'checkperiod',
						header : '核算期',
						align:'center',
						editable:false,
						width : 80,
						dataIndex : 'checkperiod'   

					},{
						id : 'changedperiod',
						header : '入参核算期',
						align:'center',
						editable:false,
						hidden:true,
						width : 80,
						dataIndex : 'changedperiod'   

					},{
						id : 'schemcode',
						header : '方案编号',
						align:'center',
						editable:false,
						width : 80,
						dataIndex : 'schemcode'

					},{
						id : 'schemname',
						header : '方案名称',
						align:'center',
						width : 180,
						editable:false,
						dataIndex : 'schemname'

					},{
						id : 'auditstate',
						header : '状态',
						editable:false,
						align:'center',
						width : 80,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'auditstate'

					}, {
						id : 'maininfo',
						header : '查看汇总表',
						editable:false,
						align:'center',
						width : 120,
						renderer : renderTopic,
						dataIndex : 'maininfo'
					}, {
						id : 'auditor',
						header : '处理人',
						align:'center',
						editable:false,
						width : 120,
						dataIndex : 'auditor'

					},{
						id : 'auditdesc',
						header : '审批意见',
						width : 250,
						editable : false,
						align:'center',
						dataIndex : 'auditdesc'
						
					}],

						split : true,
						collapsible : true,
						containerScroll : true,
						xtype : 'grid',
						trackMouseOver : true,
						stripeRows : true,
						sm : new Ext.grid.RowSelectionModel({
									singleSelect : true
								}),
						loadMask : true,
						tbar:['年度:',yearField,'-','期间类型:',periodTypeField,'-','期间:',PeriodField,'-','方案:',SchemCombox,'-','状态:',StateCombox,'-',findButton,CaluButton,SubmitButton,CancelSubmitButton,CopyScoreButton],
						height:300,
						trackMouseOver: true,
						stripeRows: true
		});

    itemGrid.btnAddHide();  //隐藏增加按钮
   	itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮

findButton.handler();
/*
itemGrid.load({	
	params:{start:0,limit:25,userCode:userCode},

	callback:function(record,options,success ){

	itemGrid.fireEvent('rowclick',this,0);
	}
});

//2016-8-24 add cyl
itemGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,record){
         var rowObj = sm.getSelections();
  
		schemmainrowid = rowObj[0].get("schemrowid");
	    var url='dhc.pa.basicuintpacaluexe.csp?action=kpilist&schem='+schemmainrowid;
		kpiTreeLoader.dataUrl=url+"&parent=0";	
	
		Ext.getCmp('kpiGrid').getNodeById("roo").reload()
  });/*
  */
itemGrid.on('rowclick',function(grid,rowIndex,e){	
	
	var clickObj=e.target; //2016-06-14 add cyl
	var clickObjClass=$(clickObj).attr("class");
	
	if(clickObjClass!="x-grid3-row-checker"){
	    var rowObj = grid.getSelectionModel().getSelections();
  
		schemmainrowid = rowObj[0].get("schemrowid");
	    var url='dhc.pa.basicuintpacaluexe.csp?action=kpilist&schem='+schemmainrowid;
		kpiTreeLoader.dataUrl=url+"&parent=0";	
	
		Ext.getCmp('kpiGrid').getNodeById("roo").reload();
	}
		
});

// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  状态
	if (columnIndex == 12) {
	var records = itemGrid.getSelectionModel().getSelections();
	var schemrowid = records[0].get("sprrowid");
	var title = records[0].get("schemname");
	StatesDetail(title,schemrowid);
	}
});

