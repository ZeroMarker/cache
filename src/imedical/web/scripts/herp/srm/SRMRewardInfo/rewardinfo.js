//var userdr = session['LOGON.USERID'];    
//var userCode = session['LOGON.USERCODE'];
var UserCode = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.rewardinfoexe.csp';
//-------------------------------------------------------
//查询条件：科室名称
var deptDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])
     });

deptDs.on('beforeload', function(ds, o){
	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'herp.srm.srmdeptuserexe.csp'
	                     +'?action=caldept&str='
	                     +encodeURIComponent(Ext.getCmp('deptField').getRawValue()),
	                     method:'POST'
		   		});
     });

var deptField = new Ext.form.ComboBox({
			id: 'deptField',
			fieldLabel: '科室名称',
			width:160,
			listWidth : 260,
			allowBlank: true,
			store: deptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			emptyText : '请选择科室姓名...',
			name: 'deptField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
	    	editable:true
});
//---------------------------------------------

var ThesisTitleField = new Ext.form.TextField({
			columnWidth : .1,
			width : 100,
			//columnWidth : .12,
			allowBlank: true,
			selectOnFocus : true

		});
var JournalNameField = new Ext.form.TextField({
			columnWidth : .1,
			width : 100,
			//columnWidth : .12,
			allowBlank: true,
			selectOnFocus : true

		});
//----------------------------------------------------------
//查询条件:第一作者
var userDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
			           totalProperty:'results',
			           root:'rows'
			       },['rowid','name'])
	     });
     
 userDs.on('beforeload', function(ds, o){
		   ds.proxy = new Ext.data.HttpProxy({
		   url: 'herp.srm.srmdeptuserexe.csp'
		         +'?action=caluser&str='
		         +encodeURIComponent(Ext.getCmp('deptField').getRawValue()),
		         method:'POST'
		   });
		         //+ Ext.getCmp('userField').getRawValue(),method:'GET'});
     });

var userField = new Ext.form.ComboBox({
			id: 'FristAuthor',
			fieldLabel: '人员名称',
			width:100,
			listWidth :260,
			allowBlank: true,
			store: userDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'请选择姓名...',
			name: 'FristAuthor',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true
});


///////////////// 查询按钮 
function rewardinfoDs(){
	   
	    var RPDeptDr = deptField.getValue();
	    var RPTitle = ThesisTitleField.getValue(); 
	   // alert(RPTitle);
	    var RPJournalName = JournalNameField.getValue();
	   // alert(RPJournalName);
	    var RPFristAuthor = userField.getValue();
		itemGrid.load({
		    params:{
		    start:0,
		    limit:15,
		    RPDeptDr:RPDeptDr,
		    RPTitle:RPTitle,
		    RPJournalName:RPJournalName,
		    RPFristAuthor:RPFristAuthor
	  }
  })
}
 
var queryPanel = new Ext.FormPanel({
			height:150,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
				xtype: 'panel',
				layout:"column",
				items: [
					{   
						xtype:'displayfield',
						value:'<center><p style="font-weight:bold;font-size:150%">论文奖励</p></center>',
						columnWidth:1,
						height:'50'
					}]
			    },{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'科室:',
						columnWidth:.04
					},
					deptField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						xtype:'displayfield',
						value:'论文题目:',
						columnWidth:.06
					},
					ThesisTitleField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						xtype:'displayfield',
						value:'期刊名字:',
						columnWidth:.06
					},
					JournalNameField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						xtype:'displayfield',
						value:'第一作者:',
						columnWidth:.06
					},
					userField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						columnWidth:.1,
						xtype:'button',
						text: '查询',
						handler:function(b){
							rewardinfoDs();
						},
						iconCls: 'add'
					}	
		     	]
			    
			}]
});	

var itemGrid = new dhc.herp.Grid({
		    //title: '论文申请审批',
		    region : 'center',
		     
		    url: projUrl,
		    atLoad : true, // 是否自动刷新
			fields : [ 
			//new Ext.grid.RowNumberer(),
			new Ext.grid.CheckboxSelectionModel({editable:false}),
			      
			      {
					    id:'ID',
				    	//header: 'ID',
				        dataIndex: 'ID',
				        align: 'center',
				        width: 30,
				        editable:false,		  
				        hidden: true,
				        sortable: true
				    },{
					    id:'RPID',
				    	header: 'ID',
				        dataIndex: 'RPID',
				        align: 'center',
				        width: 30,
				        editable:false,		  
				        hidden: true,
				        sortable: true
				    },{
					    id:'RPRecordType',
				    	header: '论文类型',
				        dataIndex: 'RPRecordType',
				        align: 'center',
				        width: 100,	
				        editable:false,
				        sortable: true
				    },{
					    id:'RPDept',
				    	header: '科室',
				        dataIndex: 'RPDept',
				        align: 'center',
				        width: 100,	
				        editable:false,
				        sortable: true
				    },{
					    id:'RPTitle',
				    	header: '论文题目',
				        dataIndex: 'RPTitle',
				        align: 'center',
				        width: 100,	
				        editable:false,	
				        sortable: true
				    },{
					    id:'RPJournalName',
				    	header: '期刊名称',
				        dataIndex: 'RPJournalName',
				        align: 'center',
				        editable:false,
				        width: 100,		  
				        sortable: true
				    },{ 
				        id:'RPCountryType',
				    	header: '期刊国别',
				        dataIndex: 'RPCountryType',
				        width: 80,
				        editable:false,  
				        sortable: true
				    },{ 
				        id:'RPFristAuthor',
				    	header: '第一作者',
				        dataIndex: 'RPFristAuthor',
				        align: 'center',
				        width: 90,	
				        editable:false,	  
				        sortable: true
				    },{ 
				        id:'RPCorrAuthor',
				    	header: '通讯作者',
				        dataIndex: 'RPCorrAuthor',
				        align: 'center',
				        editable:false,
				        width: 90,
				        //hidden:true,		  
				        sortable: true
				    },{ 
				        id:'RPPubYear',
				    	header: '年',
				        dataIndex: 'RPPubYear',
				        align: 'center',
				        width: 50,
				        editable:false,		  
				        sortable: true
				    },{ 
				        id:'RPRoll',
				    	header: '卷',
				        dataIndex: 'RPRoll',
				        align: 'center',
				        width: 50	,  
				        hidden:true,
				        editable:false,
				        sortable: true
				    },{ 
				        id:'RPPeriod',
				    	header: '期',
				        dataIndex: 'RPPeriod',
				        align: 'center',
				        width: 50,	
				        editable:false,	  
				        sortable: true
				    },{           
				         id:'RPStartPage',
				         header: '起始页',
				         width:50,
				         dataIndex: 'RPStartPage',	
				         editable:false,		  
				         sortable: true
				    },{           
				         id:'RPEndPage',
				         header: '终止页',
				         width:50,
				         dataIndex: 'RPEndPage',
				        align: 'center',	
				        editable:false,		  
				         sortable: true
				    },{           
				         id:'RPSN',
				         header: 'SN',
				         width:80,
				         dataIndex: 'RPSN',
				        align: 'center',
				        editable:false,			  
				        sortable: true
				    },{           
				         id:'RPWOS',
				         header:'入藏号',
				         width:80,
				         dataIndex: 'RPWOS',
				        align: 'center',
				        editable:false,			  
				        sortable: true
				    },{           
				         id:'RPIF',
				         header:'IF',
				         width:50,
				         dataIndex: 'RPIF',	
				        align: 'center',
				        editable:false,		  
				        sortable: true
				    },{           
				         id:'RPDocuType',
				         header:'文献类型',
				         width:80,
				         dataIndex: 'RPDocuType',
				          editable:false,		  
				        sortable: true
				    },{
					    id:'rowid',
				    	header: 'id',
				        dataIndex: 'rowid',
				        align: 'center',
				        width: 30,
				         editable:false,		  
				        hidden: true,
				        sortable: true
				    },{
					    id:'RegPaperDr',
				    	header: '论文登记表Dr',
				        dataIndex: 'RegPaperDr',
				        align: 'center',
				        editable:false,
				         hidden: true,
				        width: 50,	
				        sortable: true
				    },{           
				         id:'RewardAmount',
				         header:'奖励金额',
				         width:80,
				         dataIndex: 'RewardAmount',	
				         align: 'center',
				         allowblank:true,
				         editable:true,	
				         renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['AuditStatus']
						if (sf == "已审核") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},	 
				         sortable: true
				         
				    },{           
				         id:'AuditStatus',
				         header:'数据状态',
				         width:60,
				         dataIndex: 'AuditStatus',
				         renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['AuditStatus']
						if (sf == "已审核") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},

				        align: 'center',
				        editable:false,		  
				        sortable: true
				    },{           
				         id:'Auditor',
				         header:'审核人',
				         width:80,
				         dataIndex: 'Auditor',	
				        align: 'center',
				        allowblank:true,
				        editable:false,	  
				        sortable: true
				    },{           
				         id:'AuditDate',
				         header:'审核时间',
				         width:120,
				         dataIndex: 'AuditDate',	
				        align: 'center',
				        allowblank:true,
				        editable:false,	  
				        sortable: true
				    }]		
		});
//alert(RewardAmount);
var AuditButton  = new Ext.Toolbar.Button({
		text: '审核',  
        id:'auditButton', 
        iconCls:'option',
        handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		
		//var checker = session['LOGON.USERID'];
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		/*
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("AuditStatus")=="已审核")
		 {
			      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }else if(rowObj[j].get("RewardAmount")==""){
			       Ext.Msg.show({title:'注意',msg:'金额为空,不能审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
			 
			 }
		} */
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:'herp.srm.rewardinfoexe.csp?action=edit&&RPID='+rowObj[i].get("RPID")+'&RewardAmount='+rowObj[i].get("RewardAmount")+'&UserCode='+UserCode+'&ID='+rowObj[i].get("ID"),
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:15}});
								
							}else{
								Ext.Msg.show({title:'提示',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核该条记录吗?',handler);
    }
});

  itemGrid.addButton('-');
  itemGrid.addButton(AuditButton);
  //itemGrid.addButton('-');
  //itemGrid.addButton(NoAuditButton);
  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏重置按钮
  itemGrid.btnSaveHide(); 	//隐藏重置按钮
  itemGrid.addListener("beforeedit" ,function(cell){
	                var _record=cell.record;
					var sf=_record.get("AuditStatus");			
					if (sf=="已审核"){return false;}
					else {return true;}  
  });
 
  //itemGrid.load({params:{start:0, limit:12, userdr:userdr}});
  //itemGrid.load({params:{start:0, limit:15}});

