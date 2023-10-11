var userid = session['LOGON.USERID'];
var projUrl2 = 'herp.budg.budgprojclaimapplydetailexe.csp';

//////////////// 添加按钮  ////////////////
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var len = selectedRow.length;

		if (len < 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请先选择一个项目!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		}
		
	 var projDr=selectedRow[0].data['rowid'];      // 项目ID
	 var Username=selectedRow[0].data['username']; // 用户名
	 var projName=selectedRow[0].data['name'];     // 项目名称
	 var deptdr=selectedRow[0].data['deptdr'];     // 科室ID
	 var deptname=selectedRow[0].data['deptname']; // 科室名称
	 var year=selectedRow[0].data['year'];
	 
	 AddFun(itemDetail,projDr,projName,userid,Username,deptdr,deptname,year);
	 }
});

var UploadButton = new Ext.Toolbar.Button({
    text:'上传图片',
    tooltip:'上传图片',
    iconCls:'upload',
    //width : 70,
    //height : 30,
    handler:function(){
    
        var rowObj = itemDetail.getSelectionModel().getSelections(); 
        var len = rowObj.length;
        var message="请选择对应的单据！";  
        if(len < 1){
            Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            return false;
        }else{
            var rowid = rowObj[0].get('rowid');
            var dialog = new Ext.ux.UploadDialog.Dialog({
            url: 'herp.budg.budgprojclaimapplydetailexe.csp?action=Upload&rowid='+rowid,
            reset_on_hide: false, 
            permitted_extensions:['gif','jpeg','jpg','png','bmp'],
            allow_close_on_upload: true,
            upload_autostart: false,
            title:'上传单据信息图片'
            //post_var_name: 'file'
      });
      dialog.show();
        }
    }
});

var itemDetail = new dhc.herp.Gridapplydetail({
            title: '报销申请单',
			region : 'center',
			url : projUrl2,		
            tbar:[addButton,'-',UploadButton],
			fields : [{
						header : '支出主表ID',
						dataIndex : 'rowid',
						hidden : true
					  },{
				        id:'projdr',
				        header: '项目ID',
				        dataIndex: 'projdr',
				        width:90,
				        allowBlank: true,
						hidden: true
				      },{
						id : 'submit',
						header : '选择',
						dataIndex : 'submit',
						width : 100,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store){ 
						return '<span style="color:blue;cursor:hand"><BLINK id="submit"     onclick=submits();>      提交  </BLINK></span>'+'<b> </b>'
						+'<span style="color:blue;cursor:hand"><BLINK id="revocation" onclick=back();>  撤销  </BLINK></span>'+'<b> </b>'
						+'<span style="color:blue;cursor:hand"><BLINK id="delete"     onclick=del();>       删除  </BLINK></span>'+'<b> </b>' 
						}
					},{
						id : 'code',   //4
						header : '报销单号',
						width : 120,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'code'

					},{
						id : 'name',   //5
						header : '项目名称',
						editable:false,
						width : 200,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'name'

					},{
						id : 'deptname',
						header : '报销科室',
						editable:false,
						width : 120,
						dataIndex : 'deptname'

					},{
						id : 'username',
						header : '报销人',
						width : 100,
						editable:false,
						dataIndex : 'username'

					},{
						id : 'ApplyDate',
						header : '申请时间',
						width : 100,
						editable : false,
						align:'right',
						dataIndex : 'ApplyDate'
						
					},{
						id : 'Desc',
						header : '报销说明',
						width : 120,
						editable:false,
						dataIndex : 'Desc'

					},{
						id : 'Actmoney',
						header : '报销金额',
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'Actmoney'
						
					},{
						id : 'FundTotal',
						header : '预算总额',
						width : 120,
						editable : false,
						dataIndex : 'FundTotal',
						hidden : true
						
					},{
						id : 'ActPayWait',
						header : '在途报销',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayWait',					
						hidden : true

					},{
						id : 'ActPayMoney',
						header : '已经执行',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayMoney',
						hidden : true

					},{
						id : 'ReqMoney',
						header : '申请资金',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ReqMoney',
						hidden : true

					},{
						id : 'budgco',
						header : '预算结余',
						width : 120,
						editable:false,
						align:'right',
						dataIndex : 'budgco'

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 100,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "超出预算") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					},{
						id : 'BillState',    
						header : '单据状态',
						width : 100,
						align : 'center',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['BillState']
						if (sf == "新建") {
							return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						} else if (sf == "提交"){
							return '<span style="color:brown;cursor:hand"><u>'+value+'</u></span>';
						}else {
							return '<span style="color:black;cursor:hand"><u>'+value+'</u></span>';
						}},
						dataIndex : 'BillState'

					},{
						id : 'FundBillDR',
						header : '资金申请单ID',
						width : 100,
						editable:true,
						dataIndex : 'FundBillDR',
						hidden : true

					},{
						id : 'facode',
						header : '申请单编号',
						width : 120,
						editable:true,
						dataIndex : 'facode',
						hidden : true

					},{
						id : 'fadesc',
						header : '申请说明',
						width : 120,
						editable:true,
						dataIndex : 'fadesc',
						hidden : true

					},{
						id : 'codedesc',
						header : '资金申请单',
						width : 100,
						editable:true,
						dataIndex : 'codedesc',
						hidden : true
					},{
						id : 'File',
						header : '附件图片',
						width : 100,
						editable:true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
			 			},
						dataIndex : 'File'
					}],

					xtype : 'grid',
					loadMask : true,				
					atLoad: true
		});

//itemDetail.load({params:{start:0, limit:12,userid:userid}});
del = function(){
var selectedRow = itemGrid.getSelectionModel().getSelections();
         var selectedRow = itemDetail.getSelectionModel().getSelections();		
         var rowid	 = selectedRow[0].data['rowid'];
         var BillState  = selectedRow[0].data['BillState'];
         if(BillState=="提交"||(BillState=="通过")||(BillState=="不通过"))
         {alert("申请单已提交，不允许删除！");}
         else{
	    Ext.MessageBox.confirm('提示', '确定要删除选定的项目吗？', function(btn) {
		if (btn == 'yes') {
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var projdr=selectedRow[0].data['rowid'];
			Ext.Ajax.request({
				url: projUrl2+'?action=Del&rowid='+rowid+'&userid='+userid,
				waitMsg : '处理中...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
								title : '',
								msg : '删除成功',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
		itemGrid.load({params:{start:0, limit:25,userid:userid}});
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
		
		}
	});}
};
  
back=function(){
var selectedRow = itemDetail.getSelectionModel().getSelections();
	var selectedRow = itemDetail.getSelectionModel().getSelections();		
		var rowid	 = selectedRow[0].data['rowid'];
         var BillState  = selectedRow[0].data['BillState'];
         if(BillState=="提交"||(BillState=="通过")||(BillState=="不通过"))
         {  
	    Ext.MessageBox.confirm('提示', '确定要撤销选定的项目吗？', function(btn) {
		if (btn == 'yes') {
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var projdr=selectedRow[0].data['rowid'];
			Ext.Ajax.request({
				url: projUrl2+'?action=unsubmit&rowid='+rowid+'&userid='+userid,
				waitMsg : '处理中...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
								title : '',
								msg : '撤销成功',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
		itemGrid.load({params:{start:0, limit:25,userid:userid}});
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
		
		}
	});
         }     
        else if(BillState=="新建"){
	        alert("申请单未提交,不能撤销！");
	        }
	

};


submits=function(){

    var records = itemDetail.getSelectionModel().getSelections();
	var rowid = records[0].get("rowid")
	var BillState=records[0].get("BillState")
		
	if(BillState=="提交"||(BillState=="通过")||(BillState=="不通过"))
	{
		Ext.Msg.show({
						title : '',
						msg : '已提交的单据无需再次提交',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
		return;
	}
	
	Ext.MessageBox.confirm('提示', '确定要提交选定的项目吗？', function(btn) {
		if (btn == 'yes') {
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var projdr=selectedRow[0].data['rowid'];
			Ext.Ajax.request({
				url: projUrl2+'?action=submit&rowid='+rowid+'&userid='+userid,
				waitMsg : '处理中...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
								title : '',
								msg : '提交成功',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
	itemGrid.load({params:{start:0, limit:25,userid:userid}});
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
			
		}
		
	});

};

//////////////////// 单击gird的单元格事件  //////////////////
itemDetail.on('cellclick', function(g, rowIndex, columnIndex, e) {
 //////////////////  单击报销单号  ///////////////////////   
	if (columnIndex == 4) {	
	applynofun(itemDetail);	
	//rowid,projdr,code,deptname,username,name,Desc,facode,oldfundbilldr,BillState
	}
/////////////// 单击项目名称 ///////////////
	if (columnIndex == 5) {
		var records = itemDetail.getSelectionModel().getSelections();
		var Name		 = records[0].get("name");
		var projdr		 = records[0].get("projdr");
		projnamefun("",projdr,Name);
	}
	
////////////////// 单击单据状态  ////////////////
	if (columnIndex == 17) {
		var records = itemDetail.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Code  		 = records[0].get("code");
		var Name		 = records[0].get("name");
		statefun(FundBillDR,Code,Name);
	}
	
		//附件图片的显示
	//alert(columnIndex)
if (columnIndex == 22) {
		var records = itemDetail.getSelectionModel().getSelections();
		var rowid   = records[0].get("rowid");
		projpayuploadFun(rowid);
	}
	
/*////////////////// 单击提交 /////////////////////
	if (columnIndex == 3) {
	var records = itemDetail.getSelectionModel().getSelections();
	var rowid = records[0].get("rowid")
	var BillState=records[0].get("BillState")
		
	if(BillState != "新建")
	{
		Ext.Msg.show({
						title : '',
						msg : '已提交的单据无需再次提交',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
		return;
	}
	
	Ext.MessageBox.confirm('提示', '确定要提交选定的项目吗？', function(btn) {
		if (btn == 'yes') {
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var projdr=selectedRow[0].data['rowid'];
			Ext.Ajax.request({
				url: projUrl2+'?action=submit&rowid='+rowid+'&userid='+userid,
				waitMsg : '处理中...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
								title : '',
								msg : '提交成功',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
		itemGrid.load({params:{start:0, limit:25,userid:userid}});
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
		
		}
	});
 }	*/
});





