
var userid=session['LOGON.USERID'];
var deptdr=session['LOGON.CTLOCID'];


//提交按钮
var dauditbutton = new Ext.Toolbar.Button({
   	        text : '审核',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGridDetail.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){
			 var  state=rowObj[0].get("auditstate");
		        if (state!="已提交"){
				Ext.Msg.show({title:'注意',msg:'状态非已提交无法审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}  
			    else{var result=30 ;
			    	submitFun(itemGridDetail,result);
			    	}
		     }
			}
		}
  });

var dunauditbutton = new Ext.Toolbar.Button(
		{
		 	text : '审核不通过',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGridDetail.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){
			 var  state=rowObj[0].get("auditstate");
		        if (state!="已提交"){
				Ext.Msg.show({title:'注意',msg:'状态非已提交无法审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}  
			    else{var result=10 ;
			    	submitFun(itemGridDetail,result);
			    	}
		     }
			}
		}
		});


function renderTopic(value, p, record){
	    return String.format(
	    		"<b><a href=\""+dhcbaUrl+"/runqianReport/report/jsp/dhccpmrunqianreport.jsp?cycleDr={1}&frequency={2}&period={3}&schemDr={4}&report=HERPJXLocSumReport.raq&reportName=HERPJXLocSumReport.raq&ServerSideRedirect=dhccpmrunqianreport.csp\">考核汇总表</a></b>",
	            value, record.data.yearid,record.data.frequency,record.data.period,record.data.srowid);
}

var itemGridDetail= new dhc.herp.Gridwolf({
        title: '基层科室绩效考核结果审核',
        width: 400,
        edit:true, 
        height:300,                  //是否可编辑
        readerModel:'remote',
        region: 'south',
        url: 'dhc.pa.basedeptpacheckexe.csp',	  
		//atLoad : true, // 是否自动刷新
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
		     hidden:true,
		     dataIndex: 'auditdr'
		}, {
		     id:'desc',
		     header: '审批意见',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'desc'
		}, {
		
		     id:'auditstate',
		     header: '状态',
		     allowBlank: false,
		     
		     width:100,
		     editable:false,
		     dataIndex: 'auditstate'

		}, {
		     id:'auditdate',
		     header: '审核日期',
		     allowBlank: false,
		     width:100,
		     hidden:true,
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
		}],
        
        tbar:[dauditbutton,'-',dunauditbutton]

});


 //定义修改按钮响应函数
auditHandler = function(){
		
       
};

itemGridDetail.btnAddHide();    //隐藏增加按钮
itemGridDetail.btnSaveHide();   //隐藏保存按钮
itemGridDetail.btnDeleteHide(); //隐藏删除按钮

// 单击gird的单元格事件
itemGridDetail.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  状态
	if (columnIndex == 9) {
	var records = itemGridDetail.getSelectionModel().getSelections();
	var schemrowid = records[0].get("srowid");
	var title = records[0].get("name");
	StatesDetail(title,schemrowid);
	}
});
