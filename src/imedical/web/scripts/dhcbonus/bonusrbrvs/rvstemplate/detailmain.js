/*
* ��������ģ��
* 2016-05-05 guojing
*/



function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

var DetailUrl = '../csp/dhc.bonus.rvstemplateexe.csp';
//var DetailProxy = new Ext.data.HttpProxy({url:DetailUrl + '?action=detaillist&start=0&limit=10'});
var DetailProxy = '';

var DetailDs = new Ext.data.Store({
	proxy: DetailProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
       // 'rvsTemplateDetailID',
        'rowid',
		'rvsTemplateMainID',
		'BonusSubItemID',
		'useMinuteValue',
		'workRiskValue',
		'techDifficultyValue',
		'workCostValue',
		'makeRate',
		'execRate',
		'makeItemScore',
		'execItemScore'
	]),
    // turn on remote sorting
    //remoteSort: true     //����
    pruneModifiedRecords:true
});


var useMinuteFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data :[['5','0-20����'],['4','20-40����'],['3','40-60����'],['2','60-90����'],['1','90��������']]
      });
var useMinuteField = new Ext.form.ComboBox({
	       id : 'useMinuteField',
	       //name:'useMinuteField',
	       fieldLabel : '��ʱֵ',
	       width : 120,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : useMinuteFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  //��������ʾ��ֵ
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // ����ģʽ
	      //editable : false,
	      selectOnFocus : true,
	      forceSelection : true
      });  
      
      var workRiskFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['6','����'],['5','�ϸ�'],['4','һ��'],['3','�ϵ�'],['2','����'],['1','��']]
      });
    
      var workRiskField = new Ext.form.ComboBox({
	       id : 'workRiskField',
	       fieldLabel : '����ֵ',
	       width : 120,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : workRiskFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  //��������ʾ��ֵ
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // ����ģʽ
	      //editable : false,
	      selectOnFocus : true,
	      forceSelection : true
      });  
      
      
       var techDifficultyFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['6','����'],['5','����'],['4','һ��'],['3','����'],['2','����'],['1','��']]
      });
    
      var techDifficultyField = new Ext.form.ComboBox({
	       id : 'techDifficultyField',
	       fieldLabel : '�Ѷ�ֵ',
	       width : 120,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : techDifficultyFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  //��������ʾ��ֵ
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // ����ģʽ
	      //editable : false,
	      selectOnFocus : true,
	      forceSelection : true
      });  
      
       var workCostFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['6','���'],['5','�ϸ�'],['4','һ��'],['3','�ϵ�'],['2','���'],['1','��']]
      });
    
      var workCostField = new Ext.form.ComboBox({
	       id : 'workCostField',
	       fieldLabel : '��������ֵ',
	       width : 120,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : workCostFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // ����ģʽ
	      selectOnFocus : true,
	      forceSelection : true
	      
      });  
 
 var makeRateField = new Ext.form.TextField({
	                    id:'makeRateField',
						allowBlank:false,
						name : 'makeRate',
				        fieldLabel : '��������',
				        emptyText : '',
				        anchor : '95%'		    
					});
 
 var execRateField = new Ext.form.TextField({
	                    id:'execRateField',
						name : 'execRate',
				       fieldLabel : 'ִ�м���',
				       allowBlank : false,
				       emptyText : '',
				       anchor : '95%'		    
					});
 
 var DetailCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: 'ģ��ID',
        dataIndex: 'rvsTemplateMainID',
        width: 100,		  
        sortable: true,
        hidden:true
    },{
    	header: 'RBRVS��Ŀ',
        dataIndex: 'BonusSubItemID',
        width:80,
        sortable: true
    },{
	    header: '��ʱֵ',
        dataIndex: 'useMinuteValue',
        width: 60,
        sortable: true,
        editor:useMinuteField
        //renderer:Ext.util.Format.comboRenderer(useMinuteField)
        
	},{
    	header: '����ֵ',
        dataIndex: 'workRiskValue',
        width: 60,		  
        sortable: true,
        editor:workRiskField
    },{
    	header: '�Ѷ�ֵ',
        dataIndex: 'techDifficultyValue',
        width: 60,
        sortable: true,
        editor:techDifficultyField
    },{
	    header: '��������ֵ',
        dataIndex: 'workCostValue',
        width: 60,
        sortable: true,
        editor:workCostField
	},{
    	header: '��������',
        dataIndex: 'makeRate',
        width: 60,		  
        sortable: true,
        editor:makeRateField,
        regex:/^(-?\d+)(\.\d+)?$/,
        align : 'right'

    },{
    	header: 'ִ�м���',
        dataIndex: 'execRate',
        width: 60,
        sortable: true,
        editor:execRateField,
        regex:/^(-?\d+)(\.\d+)?$/,
        align : 'right'

    },{
    	header: '������ֵ',
        dataIndex: 'makeItemScore',
        width: 90,		  
        sortable: true,
        align : 'right'
    },{
    	header: 'ִ�з�ֵ',
        dataIndex: 'execItemScore',
        width: 90,
        sortable: true,
        align : 'right'
    }
    
]);


//��ҳ������
var DetailPagingToolbar = new Ext.PagingToolbar({
    store: DetailDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼"
	
});

var addButton = new Ext.Toolbar.Button({
	text: '���',
	tooltip: '���',
	iconCls: 'add',
	handler: function(){
		var rowObj = templateMain.getSelectionModel().getSelections();
				/*
				if (rowObj.length == 0) {
					new Ext.grid.RowSelectionModel({singleSelect:true}).selectFirstRow();
					rowObj = templateMain.getSelectionModel().getSelections();
					
				}*/
	        if (rowObj.length == 0) {
		    Ext.MessageBox.alert('��ʾ', '��û��ѡ����ģ�壬��ѡ����ģ��');
		    return false;
	        }
				
		detailAddFun();
		
	}
});

var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
	tooltip: '�޸�',
	iconCls: 'option',
	handler: function(){
		/*
		var rowObj = detailMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		*/	
		var rowObj = templateMain.getSelectionModel().getSelections();
		if (rowObj.length == 0) {
		    Ext.MessageBox.alert('��ʾ', '��û��ѡ����ģ�壬��ѡ����ģ��');
		    return false;
	        }
		
		 var minuteRate =rowObj[0].get("useMinuteRate");
		 var riskRate=rowObj[0].get("workRiskRate");
		 var difficultyRate=rowObj[0].get("techDifficultyRate");
		 var costRate=rowObj[0].get("workCostRate");

		
		//detailEditFun();
	
		var mr=DetailDs.getModifiedRecords();
		if (mr=="") {
		    Ext.MessageBox.alert('��ʾ', '�޸ļ�¼Ϊ��');
		    return false;
	        }

		var data = ""
		//var rowDelim=xRowDelim();
		
		for(i=0;i<mr.length;i++){
			var rvsTemplateMainID = mr[i].data["rvsTemplateMainID"];
			var BonusSubItemID = mr[i].data["BonusSubItemID"];
			var useMinuteValue = mr[i].data["useMinuteValue"];
			var workRiskValue = mr[i].data["workRiskValue"];
			var techDifficultyValue = mr[i].data["techDifficultyValue"];
			var workCostValue = mr[i].data["workCostValue"];
			var makeRate = mr[i].data["makeRate"];
			var execRate = mr[i].data["execRate"];
			
			if((useMinuteValue!="")&&(workRiskValue!="")&&(techDifficultyValue!="")&&(workCostValue!="")&&(makeRate!="")&&(execRate!=""))
			{
				var tmpData = mr[i].data["rowid"]+"^"+rvsTemplateMainID+"^"+BonusSubItemID+"^"+useMinuteValue+"^"+workRiskValue+"^"+techDifficultyValue+"^"+workCostValue+"^"+makeRate+"^"+execRate+"^"+minuteRate+"^"+riskRate+"^"+difficultyRate+"^"+costRate;
				if(data==""){
					data = tmpData;
				}else{
					data = data + tmpData;
					
				}
			}
		}
		//alert(tmpData)
		if(useMinuteValue==""){
			Msg.info("error", "��ʱֵ����Ϊ��!");
			return false;}
		if(workRiskValue==""){
			Msg.info("error", "����ֵ����Ϊ��!");
			return false;}
		if(techDifficultyValue==""){
			Msg.info("error", "�Ѷ�ֵ����Ϊ��!");
			return false;}
		
		if(workCostValue==""){
			Msg.info("error", "����ֵ����Ϊ��!");
			return false;}
		if(makeRate==""){
			Msg.info("error", "�������᲻��Ϊ��!");
			return false;}
		if(execRate==""){
			Msg.info("error", "ִ�м��᲻��Ϊ��!");
			return false;}else{		
		       Ext.Ajax.request({
			    
						url : DetailUrl + '?action=detailedit&data=' + tmpData,
								
						waitMsg : '������...',
						
						failure : function(result, request) {
							Ext.Msg.show({
										title : '����',
										msg : '������������!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},						
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : 'ע��',
											msg : '�����ɹ�!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								DetailDs.load({
											params : {
												start : 0,
												limit : DetailPagingToolbar.pageSize
											}
										});
								
							} else {
								var tmpmsg = '';
								if (jsonData.info == '1') {
									tmpmsg = '�����ظ�!';
								}
								Ext.Msg.show({
											title : '����',
											msg : tmpmsg,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});
	
			}
			
		
	}
});


//��������
var batchAddButton = new Ext.Toolbar.Button({
	text: '�������',
	tooltip: '�������',
	iconCls: 'add',
	handler: function(){
		templateBatchAddFun();
		
	}
});

var detailDelButton = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'remove',
	handler: function(){
		var rowObj = detailMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		
		if(len < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			tmpRowid = rowObj[0].get("rowid");
			
			Ext.MessageBox.confirm(
				'��ʾ', 
				'ȷ��Ҫɾ��ѡ������?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: DetailUrl + '?action=detaildel&rowid='+tmpRowid,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									DetailDs.load({params:{start:0, limit:DetailPagingToolbar.pageSize}});
								}else{
									Ext.Msg.show({title:'����',msg:'����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				} 
			)	
		}
	}
});


//�ɱ༭�����Ҫ��EditorGridPanel��������GridPanel
var detailMain = new Ext.grid.EditorGridPanel
({
	title:'����ģ����ϸ',
	//region:'north',
	region:'center',
	//height:250,
	store: DetailDs,
	cm: DetailCm,
	trackMouseOver: true,
	stripeRows: true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	//sm:sm,
	loadMask: true,
	clicksToEdit : 1,
	viewConfig: {forceFit:true},
	tbar:[addButton,'-',editButton,'-',detailDelButton,'-',batchAddButton],
	bbar:DetailPagingToolbar
	
});


	