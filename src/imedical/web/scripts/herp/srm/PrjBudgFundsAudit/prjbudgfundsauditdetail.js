
var userid = session['LOGON.USERID'];
var usercode = session['LOGON.USERCODE'];
var prjbudgfundsURL='herp.srm.prjbudgfundsapplyexe.csp';

var rnt="";

		
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
	editable:true
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

var AuditButton  = new Ext.Toolbar.Button({
		text : '通过',  
        id:'auditButton', 
        iconCls: 'pencil',
        handler:function(){
			
		//定义并初始化行对象
		var rowObj=prjbudgfundsDetail.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		var checker = session['LOGON.USERCODE'];
		var CheckDesc= rowObj[0].get("checkdesc")
		
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var j= 0; j < len; j++){
			if(rowObj[j].get("checkstate")!="等待审批")
		 {
			      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					Ext.Ajax.request({
					url:'herp.srm.prjbudgfundsauditexe.csp'+'?action=audit&&rowid='+rowObj[i].get("rowid")+'&userdr='+checker,
					waitMsg:'审核中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							prjbudgfundsDetail.load({params:{start:0,limit:12,usercode:checker}});
						}else{
							Ext.Msg.show({title:'错误',msg:'审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核该条记录吗?',handler);
    }
});


  var NoAuditButton = new Ext.Toolbar.Button({
					text : '不通过',
					iconCls: 'pencil',
					handler : function() {
						var rowObj=prjbudgfundsDetail.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("checkstate")!="等待审批")
							 {
								      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }else{noauditfun();}
						}
						
						
				   }
  });


var prjbudgfundsDetail = new dhc.herp.Gridlyf({
	title : '项目经费编制审核明细信息列表',
	iconCls : 'list',
    region : 'center',
    url: 'herp.srm.prjbudgfundsauditexe.csp',
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
        editable:false,
        dataIndex: 'itemlevel',
        hidden: true
		
    }, {
        id:'itemname',
        header: '经费科目名称',
        width:100,
		//tip:true,
		allowBlank: false,
        dataIndex: 'itemname',
		editable:false,
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 		
				cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
				return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
		},
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
		editable:false,
        //xtype:'numbercolumn',
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
		editable:false,
		hidden:true
    },{
        id:'fundsource',
        header: '经费来源',
        width:180,
		allowBlank: true,
		editable:false,
        dataIndex: 'fundsource',
		type:FundsSourceCombox
    },{
    	id:'budgdesc',
        header: '编制说明',
        width:100,
		editable:false,
        dataIndex: 'budgdesc'
    },{
    	id:'bottomline',
        header: '最低占比(%)',
        width:100,
        align:'right',
		editable:false,
        dataIndex: 'bottomline',
        renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
    },{
    	id:'toppercent',
        header: '最高占比(%)',
        width:100,
        align:'right',
		editable:false,
        dataIndex: 'toppercent',
        renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
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
    	id:'checkstate',
        header: '审批结果',
        width:100,
		editable:false,
        dataIndex: 'checkstate'
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
    },{
    	id:'isapproval',
        header: '是否需要审批流',
		editable:false,
        width:80,
		hidden:true,
        dataIndex: 'isapproval'
    }]		
});

prjbudgfundsDetail.hiddenButton(0)
prjbudgfundsDetail.hiddenButton(1);
prjbudgfundsDetail.hiddenButton(2);

prjbudgfundsDetail.addButton('-');
prjbudgfundsDetail.addButton(AuditButton);
prjbudgfundsDetail.addButton('-');
prjbudgfundsDetail.addButton(NoAuditButton);