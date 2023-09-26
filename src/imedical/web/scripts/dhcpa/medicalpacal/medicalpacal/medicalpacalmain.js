var userid=session['LOGON.USERID'];
var deptdr=session['LOGON.CTLOCID'];
var getFullMonth=function (date){
  if(date.getMonth()<10){
    return "0"+(date.getMonth()+1);
  }else{return date.getMonth()+1;}}
var yearField = new Ext.form.TextField({
	id: 'yearField',
	fieldLabel: '年份',
	width:100,
	regex: /^\d{4}$/,
	regexText:'年份为四位数字',
	listWidth : 245,
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
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'M', //默认值
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
periodStore.loadData([['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']]);
var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	value:getFullMonth(new Date()),
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
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

//状态
var stateStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['0','未提交'],['10','审核未通过'],['20','已提交'],['30','审核通过'],['60','发布'],['','其它']]
});
var stateField = new Ext.form.ComboBox({
	id: 'state',
	fieldLabel: '状态',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	//allowBlank: false,
	store: stateStore,
	anchor: '90%',
	//value:'M', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择状态类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var auditbutton = new Ext.Toolbar.Button({
   	        text : '发布',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要发布的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){
			//
			 var mystore=itemGridDetail.getStore();
			 var len=mystore.getCount();
			 for(var j=0;j<len;j++){
				 record=mystore.getAt(j);
				 if(record.data.auditstate=="审核未通过"){
					Ext.Msg.show({title:'注意',msg:'子方案存在审核未通过无法发布!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
					return null;
					 }
				 }
			
			/*
			 var  state=rowObj[0].get("auditstate");
		        if (state!="审核通过"){
				Ext.Msg.show({title:'注意',msg:'状态非审核通过无法发布!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}  
			    else{var result=60 ;
			    	submitFun(itemGrid,result);
			    	}
			    	*/
			    
		     }
		     	var result=60 ;
			    	submitFun(itemGrid,result);
			}
		}
  });
  var unauditbutton = new Ext.Toolbar.Button({
   	        text : '取消发布',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要取消发布的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){
			 var  state=rowObj[0].get("auditstate");
		        if (state!="发布"){
				Ext.Msg.show({title:'注意',msg:'状态非发布无法取消发布!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}  
			    else{var result=30 ;
			    	submitFun(itemGrid,result);
			    	}
		     }
			}
		}
  });

var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls:'option',
			handler : function() {
				var pattern=/^\d{4}$/;
				
				
				year=yearField.getValue();
				if(!pattern.test(year)){
					Ext.Msg.show({title:'注意',msg:'年份格式请输入四位有效数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
					return null;}
				
	
				type = periodTypeField.getValue();
	
				period = periodField.getValue();
	
				result=stateField.getValue();
				
				period=year+""+period

				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								userdr: userid,
								type : type,
								period : period,
								result:result
							}
						});

			}
			
		})
		
var calbutton = new Ext.Toolbar.Button(
		{
			text : '计算',
			tooltip : '计算',
			iconCls : 'option',
			handler : function() {
				var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid"); 
		        var srowid=rowObj[0].get("srowid"); 
		        var state=rowObj[0].get("auditstate"); 
		        if (state!="审核通过"){
				Ext.Msg.show({title:'注意',msg:'未审核通过无法计算!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}    
				//rowid, userdr,shemedr,result,chkprocdesc,desc,deptdr,chktype
		        Ext.Ajax.request({
				url:'dhc.pa.basedeptpacheckexe.csp?action=calculaotr&rowid='
				+rowid+"&userdr="+userid+"&schemedr="+srowid+"&result="+60,
		
				waitMsg:'发布中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'计算成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});		
				}
				},
				scope: this
				});
			}
});
		
		
function renderTopic(value, p, record){
	    return String.format(
	    		"<b><a href=\""+dhcbaUrl+"/runqianReport/report/jsp/dhccpmrunqianreport.jsp?cycleDr={1}&frequency={2}&period={3}&schemDr={4}&report=HERPJXLocSumReport.raq&reportName=HERPJXLocSumReport.raq&ServerSideRedirect=dhccpmrunqianreport.csp\">考核汇总表</a></b>",
	            value, record.data.yearid,record.data.frequency,record.data.period,record.data.srowid);
}
	
    function renderTopic2(value, p, record){
    	
        return String.format(
                '<b></b><a href="www.baidu.com" target="_self">lala</a>'
                );
    }
var itemGrid = new dhc.herp.Grid({
        title: '医务处绩效考核计算',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.pa.medicalpacalexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [
        new Ext.grid.CheckboxSelectionModel({editable:false}),
        {
	         id:'rowid',
		     header: '方案状态id',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'rowid'
		}, {
		     id:'period',
		     header: '核算期',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'period'
		}, {
		     id:'code',
		     header: '方案编号',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'code'
		}, {
		     id:'name',
		     header: '方案名称',
		     allowBlank: false,
		     width:160,
		     editable:false,
		     dataIndex: 'name'
		}, {
		 	 id:'nothing',
		     header: '考核汇总表',
		     allowBlank: false,
		     width:150,
		     editable:false,
		     dataIndex: 'nothing',
		     renderer : renderTopic
		}, {
		     id:'auditdr',
		     header: '发布人',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     //hidden:true,
		     dataIndex: 'auditdr'
		}, {
		     id:'auditstate',
		     header: '状态',
		     allowBlank: false,
		     
		     width:100,
		     editable:false,
		     dataIndex: 'auditstate'
		}, {
		     id:'desc',
		     header: '审批意见',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     hidden:true,
		     dataIndex: 'desc'
		}, {
		     id:'auditdate',
		     header: '审核日期',
		     allowBlank: false,
		     width:100,
		     //hidden:true,
		     editable:false,
		     dataIndex: 'auditdate'
		}, {
		     id:'srowid',
		     header: '方案id',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'srowid'

		}, {
		     id:'frequency',
		     header: '期间类型',
		     allowBlank: false,
		     hidden:true,
		     width:100,
		     editable:false,
		     dataIndex: 'frequency'
		}, {
		     id:'upschemdr',
		     header: '上级方案',
		     allowBlank: false,
		     hidden:true,
		     width:100,
		     editable:false,
		     dataIndex: 'upschemdr'
		}, {
		     id:'children',
		     header: '子科室查找',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'children',
		     renderer : renderTopic2
		}],
        
        tbar:['年度',yearField,'期间类型',periodTypeField,'期间',periodField,'状态',stateField,findButton,auditbutton,'-',unauditbutton,'-',calbutton]
        
});
findButton.handler();

 //定义修改按钮响应函数
auditHandler = function(){
		
       
};
itemGrid.btnAddHide() ;	//隐藏增加按钮
itemGrid.btnSaveHide(); 	//隐藏保存按钮
itemGrid.btnResetHide(); 	//隐藏重置按钮
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnPrintHide() ;	//隐藏打印按钮

// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  状态

	var records = itemGrid.getSelectionModel().getSelections();
	var srowid = records[0].get("srowid");
	var period = records[0].get("period");
	itemGridDetail.load({
							params : {
								start : 0,
								limit : 25,
								userdr:userid,
								schemedr: srowid,
								period : period
							}
						});
	
});
// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  状态
	if (columnIndex == 8) {
	var records = itemGrid.getSelectionModel().getSelections();
	var schemrowid = records[0].get("srowid");
	var title = records[0].get("name");
	StatesDetail(title,schemrowid);
	}
});
