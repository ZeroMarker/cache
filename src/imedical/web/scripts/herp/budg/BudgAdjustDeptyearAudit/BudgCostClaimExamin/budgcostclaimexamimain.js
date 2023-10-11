var userid = session['LOGON.USERID'];
// ���///////////////////////////////////
var projUrl = 'herp.budg.costclaimexamiexe.csp';
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=yearList',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '��������',
			store : YearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
//////��������

var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList', 

					//	method : 'POST'

                             ///   url:'herp.budg.costclaimexamiexe.csp?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()), 
                                method:'POST'

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
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


//////������
var applyerDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

applyerDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});

var applyerCombo = new Ext.form.ComboBox({
			fieldLabel : '������',
			store : applyerDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

//////��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'option',
	handler: function(){
	    var year    = yearCombo.getValue();
            var dept    = deptCombo.getValue();
	    var applyer = applyerCombo.getValue();
		itemGrid.load({params:{start:0,limit:25,year:year,userid:userid,dept:dept,applyer:applyer}});
	}
});

//////��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '���',
        tooltip:'���',        
        iconCls:'add',
	handler:function(){
	addFun();
	}
	
});


///////ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
    tooltip:'ɾ��',        
    iconCls:'add',
	handler:function(){
	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
		var len = selectedRow.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});

			return;
		}
		
        rowid	=selectedRow[0].data['rowid'];
	delFun(rowid);
	}
	
});


//////����
var backout = new Ext.Toolbar.Button({
	text: '����',
        tooltip:'����',        
        iconCls:'add',
	handler:function(){
        var selectedRow = itemGrid.getSelectionModel().getSelections();
	var len = selectedRow.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});

			return;
		}
		
         rowid	=selectedRow[0].data['rowid'];
	backoutfun(rowid,userid);
	}
	
});

//////�ύ
var submit = new Ext.Toolbar.Button({
	text: '�ύ',
        tooltip:'�ύ',        
        iconCls:'add',
	handler:function(){
        var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});

			return;
		}
		
         rowid	=selectedRow[0].data['rowid'];
         billcodes	=selectedRow[0].data['billcode'];
	submitfun(rowid,userid,billcodes);
	}
	
});

//////������ť
var adjunct = new Ext.Toolbar.Button({
	text: '����',
        tooltip:'����',        
        iconCls:'add',
	handler:function(){
	accessoryFun();
	}
	
});


var itemGrid = new dhc.herp.Grid({
		    title: 'һ��֧����������',
		    region : 'north',
		    url: 'herp.budg.costclaimexamiexe.csp',
                   /*
                    listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // �����������õ�Ԫ�����༭�Ƿ���� 
		                 if ((record.get('IsCurStep') =="0")&& (columnIndex == 2)) {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// Ԥ����Ŀ��ʽ�༭
						if (((record.get('IsCurStep') =="0")||(record.get('billstate')=="�½�")) && (columnIndex == 2)) {						
							return false;
						} else {
							return true;
						}
					}
            },
             */
			fields : [{
						header : '�����ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'select',
						header : 'ѡ��',
						editable:false,
						width : 70,
                        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
                        var checkstat = "";
						var sf = record.data['IsCurStep'];
						var cf = record.data['checkStep'];
                        checkstat = record.data['checkstate'];
                        //alert(checkstat);
                        sf=cf=1;
                        if (sf==cf&&checkstat=="����ͨ��") {
							//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:gray;cursor:hand">���</span>';
							
						} else {
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>���</u></span>';
						}},
						dataIndex : 'select'
					},{
						id : 'checkyearmonth',
						header : '��������',
						width : 80,
						editable:false,
						dataIndex : 'checkyearmonth'
					},{
						id : 'billcode',
						header : '��������',
						editable:false,
						width : 150,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:red;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'billcode'

					}, {
						id : 'dname',
						header : '��������',
						editable:false,
						width : 120,
						dataIndex : 'dname',
						hidden : false
					}, {
						id : 'applyer',
						header : '������',
						editable:false,
						width : 120,
						dataIndex : 'applyer'

					},{
						id : 'reqpay',
						header : '�������',
						width : 100,
						editable:false,
                                                align:'right',
						dataIndex : 'reqpay'

					}, {
						id : 'actpay',
						header : '�������',
						width : 100,
						editable : false,
						align:'right',
						dataIndex : 'actpay'
						
					},{
						id : 'applydate',
						header : '����ʱ��',
						width : 120,
						align : 'left',
						editable:false,
						dataIndex : 'applydate'

					},{
						id : 'billstate',
						header : '����״̬',
						width : 80,
						///align : 'right',
						editable:false,
                        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'billstate'

					},{
                        id : 'checkstate',
						header : '���״̬',
						width : 80,
						editable:false,                                  
						dataIndex : 'checkstate'

                                        },{
						id : 'applydecl',
						header : '�ʽ�����˵��',
						width : 120,
						////align : 'right',
						editable:false,
						dataIndex : 'applydecl'

					},{
						id : 'budgetsurplus',
						header : '���������',
						width : 100,
						editable:false,
						align:'right',
						dataIndex : 'budgetsurplus'

					},{
						id : 'budgcotrol',
						header : 'Ԥ�����',
						width : 60,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "Ԥ����") {
							return '<span style="color:blue;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:red;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					},{
						id : 'IsCurStep',
						header : '��ǰ����',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'IsCurStep'

					},{
						id : 'checkStep',
						header : '��������',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'checkStep'

					},{
                        id : 'applycode',
						header : '�ʽ����뵥��',
						width : 100,
						editable:false,
						align:'right',
                        hidden:true,
						dataIndex : 'applycode'

                      }, {
						id : 'deprdr',
						header : '��������',
						editable:false,
						width : 120,
						dataIndex : 'deprdr',
						hidden:true
					}, {
						id : 'audname',
						header : '��ڿ���',
						editable:false,
						width : 120,
						dataIndex : 'audname',
						hidden:false
					}, {
						id : 'audeprdr',
						header : '��ڿ���dr',
						editable:false,
						width : 120,
						dataIndex : 'audeprdr',
						hidden:true
					}, {
						id : 'CheckDR',
						header : '������',
						editable:false,
						width : 120,
						dataIndex : 'CheckDR',
						hidden:true
					}, {
						id : 'FundSour',
						header : '�ʽ���Դ',
						editable:false,
						width : 120,
						dataIndex : 'FundSour',
						hidden:true
					}, {
						id : 'FundSourN',
						header : '�ʽ���Դ',
						editable:false,
						width : 120,
						dataIndex : 'FundSourN'
					}],

						tbar:['��������:',yearCombo,'-','����','-',deptCombo,'-','������','-',applyerCombo,'-',findButton]
                                               
						
		});

    itemGrid.btnAddHide();    //�������Ӱ�ť
    itemGrid.btnSaveHide();   //���ر��水ť
    itemGrid.btnResetHide();  //�������ð�ť
    itemGrid.btnDeleteHide(); //����ɾ����ť
    itemGrid.btnPrintHide();  //���ش�ӡ��ť


itemGrid.load({	
	params:{start:0, limit:25,userdr:userid},

	callback:function(record,options,success ){

	itemGrid.fireEvent('rowclick',this,0);
	}
});



// ��������״̬ ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	if (columnIndex == 10) {
                	
		var records = itemGrid.getSelectionModel().getSelections();
	
		var rowids  = records[0].get("rowid");
	
                billstate(rowids);


	}
//�����������ŵ�Ԫ��
       else if (columnIndex == 4) {            	
                EditFun(itemGrid);
	}
       else if (columnIndex == 2) {
                var checkstat = "";	
		var records   = itemGrid.getSelectionModel().getSelections();
		var accessor  = records[0].get("accessory");
		var rowids    = records[0].get("rowid");
        var iscurrstep= records[0].get("IsCurStep");
        var checkstep = records[0].get("checkStep");
        checkstat = records[0].get("checkstate");
        iscurrstep=checkstep=1;
        if(iscurrstep==checkstep&&checkstat=="û��ͨ��")
        {
           checkFun(rowids);
        }else{
           nocheck(rowids);
           alert("�����ظ�����!");
        }
	}



});


