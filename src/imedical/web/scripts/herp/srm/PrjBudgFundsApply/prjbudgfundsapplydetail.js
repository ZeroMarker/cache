
var userid = session['LOGON.USERID'];
var usercode = session['LOGON.USERCODE'];

var prjbudgfundsURL='herp.srm.prjbudgfundsapplyexe.csp';

var rnt="";

var year=""
//预算项名称
var BIDNameDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

BIDNameDs.on('beforeload', function(ds, o){
	var selectedRow = prjbudgfundsGrid.getSelectionModel().getSelections();
	var year=selectedRow[0].data['yeardr']; 
	ds.proxy=new Ext.data.HttpProxy({
		url: prjbudgfundsURL+'?action=itemname&year='+year,method:'POST'});
		}); 
var BIDNameField = new Ext.form.ComboBox({
	id: 'BIDNameField',
	fieldLabel: '经费科目名称',
	width:120,
	listWidth : 260,
	store: BIDNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'经费科目名称...',
	name: 'BIDNameField',
	minChars: 1,
	pageSize: 10,
	editable:true ,
	listeners:{"expand":function(combo,record,index){ 
			/* alert("aaaa");
		    combo.load='2';	 */
	}}  
});

///项目经费来源 
var FundsSourceDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '申请科学事业费支持'],['2', '市财政其他专项资金拨款'],['3', '单位自筹'],['4', '国家、省专项拨款'],
		['5', '银行贷款'],['6', '其他']]
	});		
		
var FundsSourceCombox = new Ext.form.ComboBox({
	                   id : 'FundsSourceCombox',
		           fieldLabel : '经费来源',
	                   width : 260,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : FundsSourceDs,			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           mode : 'local', // 本地模式
		           editable : true,
		           selectOnFocus : true,
		           forceSelection : true
});		

/////////////////提交按钮/////////////////////
var submitButton = new Ext.Toolbar.Button({
		id:'submitButton',
		text: '提交',
        //tooltip:'提交',        
        iconCls: 'pencil',
		handler:function(){
		var rowObj = prjbudgfundsDetail.getSelectionModel().getSelections();
		
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			
			var state = rowObj[0].get("datastatus");
			var tmprowid = rowObj[0].get("rowid");
			if (tmprowid==""){
				Ext.Msg.show({title:'注意',msg:'请先保存数据再提交!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if(state == "未提交"){
				var rowObj = prjbudgfundsDetail.getSelectionModel().getSelections();     // get the selected items
				var len = rowObj.length;
				if(len > 0)
				{  
					Ext.MessageBox.confirm('提示', '确定要提交选定的行?提交后不可修改、不可删除！', function(btn) 
					{
						if(btn == 'yes')
						{	
							if(rowObj[0].get("datastatus")!="已提交"){
								for(var i = 0; i < len; i++){     		
									Ext.Ajax.request({
										url: prjbudgfundsURL+'?action=submit&rowid='+rowObj[i].get("rowid")+'&userdr='+usercode+'&sysno='+rowObj[i].get("sysno"),
										waitMsg:'提交中...',
										failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
										success: function(result, request){
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') { 
												Ext.MessageBox.alert('提示', '提交完成');
												prjbudgfundsDetail.load({params:{start:0, limit:25}});
											}
											else {
												var message = "提交失败";
												Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
										scope: this
									});
								}
							}else{
								Ext.Msg.show({title:'错误',msg:'您选择的行已提交，不可再提交!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								//return;
							}
						}
					});	
				}
				else
				{
					Ext.Msg.show({title:'提示',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				}    
			}
			else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}				
		}
});


//////////////////////////判断是否需要审批流///////////////////////////
/* Ext.Ajax.request({
	url:prjbudgfundsURL+'?action=GetIsApproval&sysno='+'P012',
	success: function(result, request){
		var jsonData = Ext.util.JSON.decode( result.responseText );				
		if (jsonData.success=='true'){				
			rnt = jsonData.info;
			if(rnt=="Y")
			{
				Ext.getCmp('submitButton').show();
				prjbudgfundsDetail.addButton('-');
				prjbudgfundsDetail.addButton(submitButton);
			}
			else{
				Ext.getCmp('submitButton').hide();
			}
		}
	},
	scope: this			
}); */
///////////////////////////////////////


var prjbudgfundsDetail = new dhc.herp.Gridlyf({
    title: '项目经费编制明细信息列表',
			iconCls: 'list',
    region : 'center',
    url: prjbudgfundsURL,
    fields: [
       new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: '科研经费编制ID',
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
        id:'itemdr',
        header: '经费科目dr',
        dataIndex: 'itemdr',
        width:80,
        editable:false,
		hidden:true
    },{ 
        id:'itemcode',
        header: '经费科目编码',
        dataIndex: 'itemcode',
        width:100,
        editable:false
    }, {
        id:'itemlevel',
        header: '经费科目级别',
        width:100,
        editable:true,
        dataIndex: 'itemlevel',
        hidden: true
		
    }, {
        id:'itemname',
        header: '经费科目名称',
        width:100,
		//tip:true,
		allowBlank: false,
        dataIndex: 'itemname',
		/* renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
				return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		}, */
        type: BIDNameField
		
    },{
        id:'bidislast',
        header: '是否末级',
        width:100,
		//tip:true,
		allowBlank: true,
        dataIndex: 'bidislast',
        hidden: true
    },{
        id:'budgvalue',
        header: '编制金额(万元)',
        width:100,       
        align:'right',
        //xtype:'numbercolumn',
        /*
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
				return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		},
		*/
        dataIndex: 'budgvalue',
        renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
    },{
        id:'fundsourcedr',
        header: '经费来源dr',
        width:140,
		allowBlank: true,
        dataIndex: 'fundsourcedr',
		hidden:true
    },{
        id:'fundsource',
        header: '经费来源',
        width:180,
		allowBlank: true,
        dataIndex: 'fundsource',
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
				return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		},
		type:FundsSourceCombox
    },{
    	id:'budgdesc',
        header: '编制说明',
        width:100,
        /*
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
				return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		},
		*/
        dataIndex: 'budgdesc'
    },{
    	id:'bottomline',
        header: '最低占比(%)',
        width:100,
		editable:false,
		align:'right',
        dataIndex: 'bottomline',
        renderer: function(val) 
		{
       		return Ext.util.Format.number(val,'0.00');
 		}
    },{
    	id:'toppercent',
        header: '最高占比(%)',
        width:100,
		editable:false,
		align:'right',
        dataIndex: 'toppercent',
        renderer: function(val) 
		{
       		return Ext.util.Format.number(val,'0.00');
    	}
    },{
    	id:'subuser',
        header: '编制人',
        width:60,
		editable:false,
        dataIndex: 'subuser'
    },{
    	id:'subdate',
        header: '编制时间',
        width:80,
		editable:false,
        dataIndex: 'subdate'
    },{
    	id:'datastatus',
        header: '状态',
		editable:false,
        width:60,
        dataIndex: 'datastatus'
    },{
    	id:'checkresult',
        header: '审批结果',
        width:180,
		editable:false,
        dataIndex: 'checkresult'
    },{
    	id:'checkdesc',
        header: '审批说明',
		editable:false,
        width:180,
        dataIndex: 'checkdesc'
    },{
    	id:'sysno',
        header: '系统号',
		editable:false,
        width:80,
		hidden:true,
        dataIndex: 'sysno'
    }/* ,{
    	id:'isapproval',
        header: '是否需要审批流',
		editable:false,
        width:80,
		hidden:true,
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				if(value=="Y")  //需要审批流
				{
					prjbudgfundsDetail.getColumnModel().setHidden(17,false);
					prjbudgfundsDetail.getColumnModel().setHidden(18,false);
					prjbudgfundsDetail.getColumnModel().setHidden(19,false);
					Ext.getCmp('submitButton').show();
				}
				else  //不需要审批流
				{
					prjbudgfundsDetail.getColumnModel().setHidden(17,true);
					prjbudgfundsDetail.getColumnModel().setHidden(18,true);
					prjbudgfundsDetail.getColumnModel().setHidden(19,true);
					Ext.getCmp('submitButton').hide();
				}
		},
        dataIndex: 'isapproval'
    } */]		
});

/* if(rnt=="Y")
{
	alert("aaa");
	Ext.getCmp('submitButton').show();
	prjbudgfundsDetail.addButton('-');
	prjbudgfundsDetail.addButton(submitButton);
}else{
	Ext.getCmp('submitButton').hide();
} */

//prjbudgfundsDetail.addButton('-');
prjbudgfundsDetail.addButton(submitButton);