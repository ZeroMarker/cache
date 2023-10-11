	userid = session['LOGON.USERID'];
var projUrl2 = 'herp.srm.PrjReimbursemendetailexe.csp';

//////////////// 添加按钮  ////////////////
var addButton = new Ext.Toolbar.Button({
	text: '新增',
    //tooltip:'添加',        
    iconCls: 'edit_add',
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
	 var Username=selectedRow[0].data['username']; // 负责人
	 var projName=selectedRow[0].data['name'];     // 项目名称
	 //var deptdr=selectedRow[0].data['deptdr'];     // 科室ID
	 //var deptname=selectedRow[0].data['deptname']; // 科室名称
	 var year=selectedRow[0].data['year'];
	 //,deptdr,deptname
	 AddFun(itemDetail,projDr,projName,userid,Username,year);
	 }
});

//修改
var editButton = new Ext.Toolbar.Button({
					text : '修改',
					//tooltip : '修改',
					iconCls: 'pencil',
					handler : function() {
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
						var selectedRow1 = itemDetail.getSelectionModel().getSelections();
											

						var len1 = selectedRow1.length;

						if (len1 < 1) {
							Ext.Msg.show({
										title : '注意',
										msg : '请先选择报销单!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.WARNING
									});
								return;
							}
        				var BillState = selectedRow1[0].data['BillState'];
        				if(BillState=="已提交")
       					 {
        					Ext.Msg.show({
								title : '',
								msg : '申请单已提交，不允许修改',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
							return;
        				  }else{applynofun(itemDetail);}
					}
				});


//删除
var delButton = new Ext.Toolbar.Button({
		text : '删除',
		//tooltip : '删除',
		iconCls: 'edit_remove',
		handler : function() {
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
        var selectedRow1 = itemDetail.getSelectionModel().getSelections();		
		var len1 = selectedRow1.length;

		if (len1 < 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请选择需要删除的报销单!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		}
        var BillState = selectedRow1[0].data['BillState'];	
        if(BillState=="已提交")
        {
	        
        	Ext.Msg.show({
						title : '',
						msg : '申请单已提交，不允许删除',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
        }
        var rowid = selectedRow1[0].data['rowid'];	

	    Ext.MessageBox.confirm('提示', '确定要删除选定的项目吗？', function(btn) {
		if (btn == 'yes') {
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var rowIndex = itemGrid.getSelectionModel().lastActive;//行号
			var projdr=selectedRow[0].data['rowid'];
			//alert("rowid:"+rowid+";userid:"+userid);
			Ext.Ajax.request({
				url: projUrl2+'?action=Del&rowid='+rowid,
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
		//alert(url);
		itemGrid.load({params:{start:0, limit:25,userid:userid}});
		var d = new Ext.util.DelayedTask(function(){  
                itemGrid.getSelectionModel().selectRow(rowIndex);
            });  
            d.delay(1000); 
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
		
		}
	});
			}
});

  var SubmitButton = new Ext.Toolbar.Button({
   	        text : '提交',
			iconCls: 'pencil',
			handler : function() {
			var rowObj = itemDetail.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			//////////////////////////判断是否有附件上传记录///////////////////////////
			
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P014',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'请上传附件!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						
							return;
						}
						
					},
					scope: this			
				  });
		///////////////////////////////////////
			
			
			
			if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("BillState");
				
			if(state == "未提交" ){ Submitfun();}
			else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可重复提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
  });	


var itemDetail = new dhc.herp.Gridapplydetail({
            title: '报销申请单',
            iconCls: 'list',
			region : 'center',
			url : projUrl2,		
            tbar:[addButton,'-',editButton,'-',delButton,'-',SubmitButton],
			fields : [{
						header : '报销主表ID',
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
						id : 'code',   //3
						header : '报销单号',
						width : 100,
						editable:false,
						dataIndex : 'code',
						renderer: function(val,cellmeta, record,rowIndex, columnIndex, store)
						{
							return '<span style="color:blue;cursor:hand"><u>'+val+'</u></span>'
						}
					},{
						id : 'name',   //4
						header : '项目名称',
						editable:false,
						width : 180,
						
						dataIndex : 'name',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'deptname',
						header : '报销科室',
						editable:false,
						width : 120,
						dataIndex : 'deptname',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'username',
						header : '报销人',
						width : 60,
						editable:false,
						dataIndex : 'username'

					},{
						id : 'Desc',
						header : '报销说明',
						width : 100,
						editable:false,
						dataIndex : 'Desc'
					},{
						id : 'Actmoney',
						header : '报销金额(元)',
						width : 100,
						editable : false,
						align:'right',
						dataIndex : 'Actmoney',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
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
						header : '编制结余(万元)',
						width : 100,
						editable:false,
						align:'right',
						dataIndex : 'budgco',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'BillState',    
						header : '单据状态',
						width : 60,
						align : 'left',
						editable:false,
						dataIndex : 'BillState'

					},{
						id : 'subuser',    
						header : '录入人',
						width : 100,
						align : 'center',
						editable:false,
						hidden : true,
						dataIndex : 'subuser'

					},{
						id : 'checkresult',    
						header : '审批结果',
						width : 180,
						align : 'left',
						editable:false,
						dataIndex : 'checkresult'

					},{
						id : 'checkdesc',    
						header : '审批意见',
						width : 180,
						align : 'left',
						editable:false,
						dataIndex : 'checkdesc'

					},{
							id:'upload',
							header: '附件',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					},{
							id:'download',
							header: '下载',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					    } 
					}],

					xtype : 'grid',
					loadMask : true,				
					atLoad: true
		});


//提交
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
			var rowIndex = itemGrid.getSelectionModel().lastActive;//行号
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
	var d = new Ext.util.DelayedTask(function(){  
                itemGrid.getSelectionModel().selectRow(rowIndex);
            });  
            d.delay(1000); 
            
		itemGrid.getSelectionModel().selectRow(rowIndex);
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
			
		}
		
	});

};

uploadMainFun(itemDetail,'rowid','P014',18);
downloadMainFun(itemDetail,'rowid','P014',19);

//////////////////// 单击gird的单元格事件  //////////////////
itemDetail.on('cellclick', function(g, rowIndex, columnIndex, e) {
 //////////////////  单击报销单号  ///////////////////////  
 
	if (columnIndex == 3) {	
	applynofun(itemDetail);	
	//rowid,projdr,code,deptname,username,name,Desc,facode,oldfundbilldr,BillState
	}
/* 
/////////////// 单击项目名称 ///////////////
	if (columnIndex == 5) {
		var records = itemDetail.getSelectionModel().getSelections();
		var Name		 = records[0].get("name");
		var projdr		 = records[0].get("projdr");
		projnamefun(projdr,Name);
	}
*/

});