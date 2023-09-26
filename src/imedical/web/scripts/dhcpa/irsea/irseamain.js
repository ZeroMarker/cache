//*name:自查报告审批主程序
  //*author:黄凤杰
  //*Date:2015-5-18
/*var getFullPeriodType = function (date) {
  var d = date.getMonth();
  d=d/3+1;
  var m ="0"+parseInt(d)-1;
  if (m<1){return "04";}
  else
  {return m;}

}*/
var getFullPeriodType = function (date) {
  var d = date.getMonth();
 
  var m ="0"+parseInt(d)-1;
  if (m<1){return "12";}
  else
  {return m;}

}
var periodYear = new Ext.form.TextField({
	id: 'periodYear',
	fieldLabel: '年度',
	width:50,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'请输入四位数字的年份',
	value:(new Date()).getFullYear(),
	name: 'periodYear',
	minChars: 1,
	pageSize: 10,
	editable:false
});

var dataStr="";

var data="";
var data1=[['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']];
var data2=[['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']];
var data3=[['01','1~6上半年'],['02','7~12下半年']];
var data4=[['00','全年']];
var count1=0;
var count2=0;

var monthStore="";



var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:50,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'M',
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
		nameDs.removeAll();   
        nameField.setValue('');
        nameDs.proxy = new Ext.data.HttpProxy({url:itemGridUrl+'?action=nameList&userID='+userID+'&periodType='+encodeURIComponent(Ext.getCmp('periodTypeField').getValue()),method:'POST'});
		nameDs.load({params:{start:0,limit:10}});
	}}   
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	startperiodStore.loadData(data);
	endperiodStore.loadData(data);
	
});

startperiodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
startperiodStore.loadData([['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']]);

var startperiodField = new Ext.form.ComboBox({
	id: 'startperiodField',
	fieldLabel: '',
	value:'01',
	width:80,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: startperiodStore,
	anchor: '90%',
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
endperiodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
endperiodStore.loadData([['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']]);

var endperiodField = new Ext.form.ComboBox({
	id: 'endperiodField',
	fieldLabel: '',
	//value:'0'+getFullPeriodType(new Date()),
	value:'0'+getFullPeriodType(new Date()),
	width:80,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: endperiodStore,
	anchor: '90%',
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

var nameDs = new Ext.data.Store({   //解析数据源
           
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'	
			},['groupRowid','groupName'])	
});

nameDs.on('beforeload',function(ds,o){  //数据源监听函数调用后台类方法查询数据
    var periodType=periodTypeField.getValue();
	ds.proxy = new Ext.data.HttpProxy({
		url:'dhc.pa.uirseaexe.csp'+'?action=nameList&userID='+userID+'&periodType='+periodType,method:'POST'
	});	
});

var nameField = new Ext.form.ComboBox({   //定义单位组合控件
            id: 'nameField',
			fieldLabel: '自查名称',
			width: 120,
			listWidth: 240,
			selectOnFocus: true	,
			store: nameDs,
			anchor: '90%',
	        valueNotFoundText:'',
			displayField: 'groupName',
			valueField: 'groupRowid',
			triggerAction: 'all',
			emptyText: '请选择...',
			typeAhead: true,
			forceSelection: true,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
	        forceSelection: true		
});
        var CycleDr= periodYear.getValue();
        var startperiod = startperiodField.getValue();
        var endperiod = endperiodField.getValue();
        var periodType = periodTypeField.getValue();
        var name = nameField.getValue();
        var userID = session['LOGON.USERID'];

var itemGridUrl = '../csp/dhc.pa.uirseaexe.csp';
//配件数据源

var itemGridProxy= new Ext.data.HttpProxy({url: itemGridUrl + '?action=list&CycleDr='+ CycleDr+'&startperiod=' + startperiod+'&endperiod=' + endperiod+'&periodType=' + periodType+'&name=' + name+'&userID=' + userID
						});
var userID = session['LOGON.USERID'];
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
	         'rowid',
			'deptname',
			'cmd',
			'startperiod',
			'endperiod',
			'period',
			'code',
			'periodYear',
			'periodmonth',
			'periodType',
			'submitStateName',
			'auditStateName',
			'updateStateName',
			'namedr',
			'name',
			'updateUserName',
			'updateDate',
			'submiUserName',
			'submiDate',
			'auditUserName',
			'auditDate'
		]),
	    remoteSort: true
});

//添加复选框
var sm = new Ext.grid.CheckboxSelectionModel();
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'Name');








//var tmpTitle='机构等级';

//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
    sm,
        new Ext.grid.RowNumberer(),
         {
			header : 'ID',
			dataIndex : 'rowid',
			width : 40,
			hidden : true,
			sortable : true
		}, {

            id:'deptname',
            header: '科室',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'deptname'
            
           
       },{

            id:'cmd',
            header: 'cmd',
            allowBlank: false,
            width:100,
            editable:false,
            hidden : true,
            dataIndex: 'cmd'
            
           
       },  {
		    id:'period',
			header: '期间',
			dataIndex: 'period',
		    width: 100,		  
			
			sortable: true
		},{
            id:'code',
            header: '自查代码',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'code'
            
       },{
            id:'name',
            header: '自查名称',
            allowBlank: false,
            width:100,
           editable:false,
            
            dataIndex: 'name'
            
       },{
            id:'submitStateName',
            header: '状态',
            allowBlank: false,
            width:100,
            editable:false,
            
            renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
	            var sf = record.data['submitStateName']
						           //return '<span style="color:blue;cursor:hand">'+value+'</span>';
						 if (sf == "已提交") {
								return '<span style="color:blue;cursor:hand"><u>'
										+ value + '</u></span>';
							} else  {
								return '<span style="color:red;cursor:hand"><u>'
										+value + '</u></span>';
							}
	             
	             
	             },
            dataIndex: 'submitStateName'
            
       },{
            id:'submiUserName',
            header: '提交人',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'submiUserName'
            
       }, {
            id:'submiDate',
            header: '提交时间',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'submiDate'
            
       }, {
            id:'auditStateName',
            header: '评审状态',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'auditStateName'
            
       },{
            id:'auditUserName',
            header: '评审人',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'auditUserName'
            
       },{
            id:'auditDate',
            header: '评审时间',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'auditDate'
            
       }, {
            id:'updateStateName',
            header: '修改状态',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'updateStateName'
            
       },{
            id:'updateUserName',
            header: '修改人',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'updateUserName'
            
       },{
            id:'updateDate',
            header: '修改时间',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'updateDate'
            
       },{
							id:'download',
							header: '附件',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
								//alert(itemGrid1);
							return '<span style="color:blue"><u>下载</u></span>';
							//return '<span style="color:gray;cursor:hand">审核</span>';
					    } 
       }
			    
]);

//查询功能
var SearchButton = new Ext.Toolbar.Button({
    text: '查询', 
    tooltip:'查询',        
    iconCls:'search',
	handler:function(){	
         var CycleDr= periodYear.getValue();
        var startperiod = startperiodField.getValue();
        var endperiod = endperiodField.getValue();
        var periodType = periodTypeField.getValue();
        var name = nameField.getValue();
        var userID = session['LOGON.USERID'];
       if((CycleDr=="")||(CycleDr=="null")){
			Ext.Msg.show({title:'注意',msg:'年份不能为空,请输入年份!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
		
		if((startperiod=="")||(startperiod=="null")){
			Ext.Msg.show({title:'注意',msg:'开始期间不能为空,请选择开始期间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
		if((endperiod=="")||(endperiod=="null")){
			Ext.Msg.show({title:'注意',msg:'结束期间不能为空,请选择结束期间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
		if((periodType=="")||(periodType=="null")){
			Ext.Msg.show({title:'注意',msg:'期间类型不能为空,请选择期间类型!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
		
	itemGridDs.load(({params:{start:0,limit:itemGridPagingToolbar.pageSize,CycleDr:CycleDr,startperiod:startperiod,endperiod:endperiod,periodType:periodType,name:name,userID:userID}}));
	
	}
});
///评审按钮
var AuditingButton = new Ext.Toolbar.Button({
			text : '评审',
			tooltip : '评审',
			iconCls : 'audit',
			handler : function() {
				itemAuditing(itemGrid, itemGridDs);
			}
		});
function itemAuditing(itemGrid, itemDs) {
    
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要评审的数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}

	var rowid = rowObj[0].get("rowid")
	var isCalc = rowObj[0].get("submitStateName")
	var IsAuditing = rowObj[0].get("auditStateName")
    var userID = session['LOGON.USERID'];
	if (isCalc == "未提交") {
		Ext.Msg.show({
					title : '注意',
					msg : '该方案未提交，请先进行提交!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}
	if (IsAuditing == "审核通过") {
		Ext.Msg.show({
					title : '注意',
					msg : '该记录已经审核!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}

	Ext.MessageBox.confirm('提示', '确实要审核该记录吗?', Auditing);

	function Auditing(id) {

		if (id == 'yes') {

			Ext.Ajax.request({
				url : itemGridUrl + '?action=Auditing&rowid=' + rowid+'&userID=' + userID
						+ '&IsAuditing=1',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var rtn = result.responseText;
					if (rtn == 0) {
						Ext.Msg.show({
									title : '注意',
									msg : '数据审核成功!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						itemGridDs.load({
							params : {
								CycleDr : Ext.getCmp('periodYear').getValue(),
								startperiod : Ext.getCmp('startperiodField').getValue(),
								endperiod : Ext.getCmp('endperiodField').getValue(),
								periodType : Ext.getCmp('periodTypeField').getValue(),
								name : Ext.getCmp('nameField').getValue(),
								userID : session['LOGON.USERID'],
								start : 0,
								limit : itemGridPagingToolbar.pageSize
							}
						});

						window.close();
					} else {
						var message = "";
						message = "记录审核失败！";
						Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					}
				},
				scope : this
			});

		}
	}

}
var editButton = new Ext.Toolbar.Button({
					text : '允许修改',
					tooltip : '允许修改',
					iconCls : 'edit',
					handler : function() {
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
		 var rowId = rowObj[0].get("rowid");                 
		var isCalc = rowObj[0].get("submitStateName")
	var IsAuditing = rowObj[0].get("auditStateName")
    var update = rowObj[0].get("updateStateName")
	if (isCalc == "未提交") {
		Ext.Msg.show({
					title : '注意',
					msg : '该方案未提交，请先进行提交!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}
	if (IsAuditing == "审核通过") {
		Ext.Msg.show({
					title : '注意',
					msg : '该记录已经审核!无法修改',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}		
	if (update == "允许修改") {
		Ext.Msg.show({
					title : '注意',
					msg : '该记录已经允许修改',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}		
				//var type = uTypeField.getValue(); 
              
                Ext.Ajax.request({
				url:'dhc.pa.uirseaexe.csp?action=edit&rowId='+rowId,
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize,CycleDr:Ext.getCmp('periodYear').getValue(),startperiod:Ext.getCmp('startperiodField').getValue(),endperiod:Ext.getCmp('endperiodField').getValue(),periodType:Ext.getCmp('periodTypeField').getValue(),name:Ext.getCmp('nameField').getValue(),userID:session['LOGON.USERID']}});
					
								
										
				}
				else
					{
						var message="已存在相同记录";
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					};
			},
				scope: this
			});
			
		}

				});

var itemGrid = new Ext.grid.GridPanel({
			//title: '系统模块定义',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'dhc.pa.uirseaexe.csp',
		    //atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: sm,
			loadMask: true,
			tbar:['年度:','-',periodYear,'期间类型:','-',periodTypeField,'-','开始期间:','-',startperiodField,'-','结束期间:','-',endperiodField,'-','自查名称:','-',nameField,'-',SearchButton,'-',AuditingButton,'-',editButton],
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 //alert(columnIndex)
	if (columnIndex ==8) {
		var records = itemGrid.getSelectionModel().getSelections();
		var rowid = records[0].get("rowid");
		var submitStateName = records[0].get("submitStateName");
		if(submitStateName== '已提交'){
		
		sysdeptkindeditFun (submitStateName,rowid);
		}
		else {}
	}
	if (columnIndex ==17) {
		var records = itemGrid.getSelectionModel().getSelections();
		var UDRDDr = records[0].get("cmd");
		//alert(UDRDDr);
		/*var submitStateName = records[0].get("submitStateName");
		if(submitStateName== '已提交'){
		
		sysdeptkindeditFun (submitStateName,rowid);
		}
		else {}*/
		downloadFun(UDRDDr,itemGrid);
	}
	});
	

