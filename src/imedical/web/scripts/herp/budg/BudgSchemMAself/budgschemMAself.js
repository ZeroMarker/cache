var userdr = session['LOGON.USERID'];
var CTLOCID = session['LOGON.CTLOCID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
// ���///////////////////////////////////
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

smYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgcommoncomboxexe.csp?action=year',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '���',
			store : smYearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true,
			listeners:{
            "select":function(combo,record,index){
	            deptDs.removeAll();     
				deptCombo.setValue('');
				deptDs.proxy = new Ext.data.HttpProxy({url:'herp.budg.budgschemaselfexe.csp?action=deptNList&year='+combo.value,method:'POST'})  
				deptDs.load({params:{start:0,limit:10}});      					
			}
	   }
		});
		
// ////////////��������////////////////////////
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
var year =yearCombo.getValue();
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgschemaselfexe.csp?action=deptNList',
						method : 'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '��������',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


//�Ƿ��Ѿ�����
var IsCheckStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','��'],['0','��']]
});
var IsCheckCom= new Ext.form.ComboBox({
	id: 'IsCheck',
	fieldLabel: '�Ƿ��ǵ�ǰ����',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	store: IsCheckStore,
	anchor: '90%',
	// value:'key', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	// emptyText:'ѡ��ģ������...',
	mode: 'local', // ����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 15,
	selectOnFocus:true,
	forceSelection:true
});

//����״̬
var ChkStateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','�½�'],['2','�ύ'],['3','ͨ��'],['4','���']]
});
var ChkStateStoreField = new Ext.form.ComboBox({
	id: 'ChkStateStoreField',
	fieldLabel: '����״̬',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: ChkStateStore,
	anchor: '90%',
	// value:'key', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	// emptyText:'ѡ��ģ������...',
	mode: 'local', // ����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 15,
	selectOnFocus:true,
	forceSelection:true
});

var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'option',
	handler: function(){
	
	      	var year = yearCombo.getValue();
				//alert(year);
			var deptcode = deptCombo.getValue();
			if(deptcode== "")
			{
				Ext.Msg.show({title:'ע��',msg:'����ѡ����ң�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			
			itemGrid.load({params : {start : 0,limit : 25,year : year,dcode : deptcode}});
	}
});

var calculateButton = new Ext.Toolbar.Button({
	text: '����',
	tooltip: '����',
	iconCls: 'option',
	handler: function(){
	
			
			var selectedRow = itemGrid.getSelectionModel().getSelections();
    		var len = selectedRow.length;
    		if(len <=0){
		    Ext.Msg.show({title:'ע��',msg:'����ѡ�񷽰���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	        }
    		var SchemDR = selectedRow[0].get("rowid");
    		var year = yearCombo.getValue();
    		var deptcode = deptCombo.getValue();
    		
	   		if(year ==""){
		    Ext.Msg.show({title:'ע��',msg:'����ѡ����ȣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	        }
	        if(deptcode==""){
	         Ext.Msg.show({title:'ע��',msg:'����ѡ����ң�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	        }
	        else{
			
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ������', function(btn) {
			if (btn == 'yes') {
				var surl = 'herp.budg.budgschemaselfexe.csp?action=calulate&year='+ year+'&objdeptdr='+deptcode+'&SchemDR='+SchemDR+'&AdjustNo=0&ChangeFlag=1';
				itemGrid.saveurl(surl)
			}
		});
	}
	}
});

var itemGrid = new dhc.herp.Gridhss({
            title : '���ҿ�ĿԤ�����',
			region : 'north',
			url : 'herp.budg.budgschemaselfexe.csp',
			fields : [{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
	            		id : 'CompName',
	       	 			header : 'ҽ�Ƶ�λ',
                        width : 90,
                        editable : false,
                        hidden : true,
                     	dataIndex : 'CompName'
	    			},{
						id : 'Year',
						header : '���',
						dataIndex : 'Year',
						width : 60,
						editable:false,
						hidden : false
					}, {
						id : 'Code',
						header : '��������',
						width : 70,
						editable:false,
						allowBlank : false,
						dataIndex : 'Code'
					}, {
						id : 'Name',
						header : '��������',
						width : 120,
						editable:false,
						allowBlank : false,
						dataIndex : 'Name'
					},{
						id : 'OrderBy',
						header : '����˳��',
						editable:false,
						width : 60,
						dataIndex : 'OrderBy'
					}, {
						id : 'ItemName',
						header : '���Ԥ����',
						editable:false,
						width : 60,
						dataIndex : 'ItemName'
					}, {
						header : 'ǰ�÷���',
						editable : false,
						align : 'center',
						renderer : function(v, p, r) {
							return '<span style="color:blue;cursor:hand"><u>��ѯ</u></span>';								
						},
						dataIndex : 'SupSchem'
					},{
						id : 'IsHelpEdit',
						header : '�Ƿ����',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'IsHelpEdit'

					}, {
						id : 'ChkState',
						header : '����״̬',
						width : 60,
						editable : false,
						dataIndex : 'ChkState',
						type:ChkStateStoreField
						
					},{
						header : '���Ʋ���',
						editable : false,
						align : 'center',
						dataIndex : 'ChkStep'
					},{
						id : 'CHKFlowDR',
						header : '������',
						hidden:true,
						width : 60,
						editable:false,
						dataIndex : 'CHKFlowDR'
					},{
						id : 'ChkFlowName',
						header : '������',
						width : 60,
						editable:false,
						dataIndex : 'ChkFlowName'
					},{
						id : 'File',
						header : '�ļ�',
						width : 60,
						editable:false,
						//hidden:true,
						dataIndex : 'File'
					},{
						id : 'Initials',
						header : '��¼�û���',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'Initials'

					},{
						id:'IsCurStep',
						header: '�Ƿ�Ϊ��ǰ����',
						width:110,
						//tip:true,
						allowBlank: true,
						editable:false,
						update:true,
						dataIndex: 'IsCurStep',
						hidden: true,
						type:IsCheckCom
					},{
						id:'schemAuditDR',
        				header: '������ڱ�ID',
        				width:110,
	    				//tip:true,
	    				allowBlank: true,
	    				editable:false,
	    				hidden: true,
        				dataIndex: 'schemAuditDR'
        	
    				},{
    					id:'CurStepNO',
        				header: '��ǰ����˳���',
        				width:110,
	    				editable:false,
	    				hidden: true,
        				dataIndex: 'CurStepNO'
        	
    				},{
    					id:'StepNOC',
        				header: '��������˳���',
        				width:110,
	    				editable:false,
	    				hidden: true,
        				dataIndex: 'StepNOC'
        	
    				},{
    					id:'StepNO',
        				header: '����������˳���',
        				width:150,
						editable:false,
	    				hidden: true,
        				dataIndex: 'StepNO'
        	
    				}],
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					loadMask : true,
					viewConfig : {
						forceFit : true
					},
					tbar : ['���:', yearCombo, '��������:', deptCombo, '-', findButton,'-',calculateButton],
					height:230,
					trackMouseOver: true,
					stripeRows: true

		});

    //itemGrid.btnAddHide();  //�������Ӱ�ť
    itemGrid.btnSaveHide();  //���ر��水ť
    //itemGrid.btnResetHide();  //�������ð�ť
    //itemGrid.btnDeleteHide(); //����ɾ����ť
   // itemGrid.btnPrintHide();  //���ش�ӡ��ť


/*itemGrid.load({	
	params:{start:0, limit:12,userdr:userdr}

	//callback:function(record,options,success ){
		//alert("a")
	//selfitemGrid.fireEvent('rowclick',this,0);
	//}
});*/

itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var iscurstep='';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var iscurstep=selectedRow[0].data['IsCurStep'];
	var StepNO=selectedRow[0].data['StepNOC'];  //����˳���
	var CurStepNO=selectedRow[0].data['CurStepNO'];
	var BillState=selectedRow[0].data['ChkState'];
	var year = selectedRow[0].data['Year'];
	var schemeDr=selectedRow[0].data['rowid'];
	
	var tbar = selfitemGrid.getTopToolbar();
	var saveButton = tbar.get('herpSaveId');
	
		if(BillState=='2'){
			backoutButton.enable();
			saveButton.disable();
		 	submitButton.disable()
		}
		if((StepNO>=CurStepNO)&&(BillState!=='1')&&((StepNO!=="")&&(CurStepNO!==""))) {
			backoutButton.enable();
			submitButton.disable();
		 	saveButton.disable();
		}if(BillState=='1'){
			backoutButton.disable();
			submitButton.enable();
		 	saveButton.enable();
		}
		 
	var dcode = deptCombo.getValue();
	
	if(dcode!="")
	{
		selfitemGrid.load({params:{start:0, limit:12,SchemDr:schemeDr,dcode:dcode,year:year}});
	}
	else{
		Ext.Msg.show({title:'ע��',msg:'����ѡ����ң�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}	
});


// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 //alert(columnIndex)
	// ǰ�÷�������
	if (columnIndex == 8) {
		var records = itemGrid.getSelectionModel().getSelections();
		var schmDr = records[0].get("rowid");
		var schmName = records[0].get("Name");
		var OrderBy = records[0].get("OrderBy");
		var year = records[0].get("Year");
        //alert(OrderBy);
		// Ԥ�㷽���༭ҳ��
		supSchemeFun(schmDr, schmName, year, OrderBy);
	}

});


