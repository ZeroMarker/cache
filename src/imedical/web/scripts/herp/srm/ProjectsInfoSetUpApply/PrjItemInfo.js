var projUrl = 'herp.srm.horizonalprjapplyItemInfoexe.csp';

//alert(Year);
 
 //////��Ŀ��Ϣ
var ItemDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

ItemDs.on('beforeload', function(ds, o) {
      var selectedRow = itemGrid.getSelectionModel().getSelections();
	    var year=selectedRow[0].data['YearCode'];
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.srm.horizonalprjapplyItemInfoexe.csp'+'?action=ItemList'+'&year='+year,
						method : 'POST'
					});
		});

var ItemCombo = new Ext.form.ComboBox({
	    id :'ItemCombo',
			store : ItemDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			name :'ItemCombo',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
	//////��Ŀ��Ϣ
var PrjInfoDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

PrjInfoDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=PrjInfoList',
						method : 'POST'
					});
		});

var PrjInfoCombox = new Ext.form.ComboBox({
	    id :'PrjInfoCombox',
			store : PrjInfoDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			name :'PrjInfoCombox',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
	var PrjItemInfoGrid = new dhc.herp.Gridhs({
				//title : "������Ϣ",
				region : 'center',                          
        url : 'herp.srm.horizonalprjapplyItemInfoexe.csp',
				fields : [
              new Ext.grid.CheckboxSelectionModel({editable:false}),
           {
							id : 'rowid',
							header : 'ID',
							dataIndex : 'rowid',
							width : 120,
							align : 'center',
							editable:false,
							hidden:true
						},{
							id : 'ItemName',
							header : '����',
							dataIndex : 'ItemName',
							width : 120,
							align : 'center',
							allowBlank: false,
							editable:true,
							type:ItemCombo
						},{
							id : 'Total',
							header : '��Ŀ��Ͷ��(��Ԫ)',
							dataIndex : 'Total',
							width : 120,
							align : 'left',
							editable:true,
							allowBlank: false,
							hidden : false,
							type:'numberField'
						},{
							id : 'FundGov',
							header : '����:�ϼ�����(��Ԫ)',
							dataIndex : 'FundGov',
							width : 120,
							allowBlank: false,
              editable:true,
							align : 'center',
							type:'numberField'
						},{
							id : 'FuncDesc',
							header : '����������˵��',
							allowBlank: false,
							dataIndex : 'FuncDesc',
							width : 120,
              editable:true,
							align : 'center'
						}]    
			});
// PrjItemInfoGrid.btnAddHide();  //�������Ӱ�ť
// PrjItemInfoGrid.btnSaveHide();  //���ر��水ť
// PrjItemInfoGrid.btnDeleteHide(); //����ɾ����ť
 //PrjItemInfoGrid.btnResetHide();  //�������ð�ť
 //PrjItemInfoGrid.btnPrintHide();  //���ش�ӡ��ť