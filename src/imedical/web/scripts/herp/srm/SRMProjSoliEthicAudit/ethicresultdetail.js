
var userid = session['LOGON.USERID'];
var usercode = session['LOGON.USERCODE'];
var prjbudgfundsURL='herp.srm.srmprosoliethicauditexe.csp';

var rnt="";

///审核结果
var EthicResultDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '审核通过'],['2', '修改后重审'],['3', '修改后提交']]
	});		
		
var EthicResultCombox = new Ext.form.ComboBox({
	                   id : 'EthicResultCombox',
		           fieldLabel : '审核结果',
	                   width : 245,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : EthicResultDs,			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           mode : 'local', // 本地模式
		           editable : true,
		           selectOnFocus : true,
		           forceSelection : true
});		

/////////////////反馈按钮/////////////////////
var FeedBackButton = new Ext.Toolbar.Button({
		id:'FeedBackButton',
		text: '反馈至申请人',
        tooltip:'反馈至申请人',        
        iconCls: 'pencil',
		handler:function(){
		var rowObj = EthicResultGrid.getSelectionModel().getSelections();
		
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要反馈的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			
			var isfeedback = rowObj[0].get("IsFeedBack");
			if(isfeedback != "是"){
				var rowObj = EthicResultGrid.getSelectionModel().getSelections();     // get the selected items
				var len = rowObj.length;
				if(len > 0)
				{  
					Ext.MessageBox.confirm('提示', '确定要把该结果反馈至申请人?反馈后不可修改、不可删除！', function(btn) 
					{
						if(btn == 'yes')
						{	
							if(rowObj[0].get("IsFeedBack")!="是"){
								for(var i = 0; i < len; i++){     		
									Ext.Ajax.request({
										url: prjbudgfundsURL+'?action=feedback&rowid='+rowObj[i].get("rowid"),
										waitMsg:'提交中...',
										failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
										success: function(result, request){
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') { 
												Ext.MessageBox.alert('提示', '反馈完成');
												EthicResultGrid.load({params:{start:0, limit:25}});
												itemGrid.load({params:{start:0, limit:25}});
											}
											else {
												var message = "反馈失败";
												Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
										scope: this
									});
								}
							}else{
								Ext.Msg.show({title:'错误',msg:'您选择的审核结果已反馈，不可再次反馈!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								//return;
							}
						}
					});	
				}
				else
				{
					Ext.Msg.show({title:'提示',msg:'请选择需要反馈的审核结果!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				}    
			}
			else {Ext.Msg.show({title:'警告',msg:'审核结果已提交，不可再次反馈！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}				
		}
});

////////////////提交按钮//////////////////////////
var submitProSoliInfoButton  = new Ext.Toolbar.Button
({
		text: '提交至科研处',        
		iconCls: 'pencil',
		id: 'submitProSoliInfoButton',
		handler: function()
		{
			/* var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'提示',msg:'请选择需要提交项目申请!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			} */
			var DetailObj = EthicResultGrid.getSelectionModel().getSelections();
			var detaillen = DetailObj.length; 
			if(detaillen < 1)
			{
				Ext.Msg.show({title:'提示',msg:'请选择需要提交的伦理审核结果!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			for(var j= 0; j < detaillen; j++)
			{
				var state = DetailObj[0].get("DataStatus");		
				if(state != '是')
				{
					submitFun();
				}
				else
				{
					{Ext.Msg.show({title:'警告',msg:'审核结果已提交，不可再次提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
				}
			}
		}
});
var EthicResultGrid = new dhc.herp.Gridlyf({
    region : 'center',
	title: '项目征集伦理审核查询列表',
	iconCls: 'list',
    url: prjbudgfundsURL,
    fields: [
       new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: '项目征集伦理审核',
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'prjrowid',
        header: '项目ID',
        dataIndex: 'prjrowid',
        width:90,
        allowBlank: true,
		hidden: true
    },{ 
        id:'EthicChkResult',
        header: '伦理审核结果',
        dataIndex: 'EthicChkResult',
        width:120,
        editable:true,
		hidden:false,
		update:true,
		type:EthicResultCombox
    },{ 
        id:'EthicAuditDesc',
        header: '伦理审核说明',
        dataIndex: 'EthicAuditDesc',
        width:180,
		update:true,
        editable:true
    },{
        id:'EthicAuditDate',
        header: '审核时间',
        width:100,
		allowBlank: true,
		editable:false,
        dataIndex: 'EthicAuditDate'
    }, {
        id:'SubUser',
        header: '填写人',
        width:100,
        editable:false,
        dataIndex: 'SubUser',
        hidden: false	
    },{
    	id:'IsFeedBack',
        header: '是否反馈',
		editable:false,
        width:80,
        dataIndex: 'IsFeedBack'
    },{
    	id:'DataStatus',
        header: '是否提交',
        width:180,
		editable:false,
        dataIndex: 'DataStatus'
    }]		
});

EthicResultGrid.addButton('-');
EthicResultGrid.addButton(FeedBackButton);

EthicResultGrid.addButton('-');
EthicResultGrid.addButton(submitProSoliInfoButton);