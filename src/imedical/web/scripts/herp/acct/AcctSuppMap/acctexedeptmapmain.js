
////////////////// 核算执行部门类别 ///////////////////
var BusiCodeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

BusiCodeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctsuppmapexe.csp?action=BusiCodeList',
						method : 'POST'
					});
		});

var BusiCodeCom = new Ext.form.ComboBox({
			id:'BusiCodeCom',
			store : BusiCodeDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		




//////////////////////////////////////////



var itemGrid = new dhc.herp.Grid({
        title: '供应商映射维护',
        width: 400,
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctsuppmapexe.csp',	  
		atLoad : true, 
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'BusiCode',
            header: '业务模块',
			allowBlank: true,
			width:200,
            dataIndex: 'BusiCode',
            type:BusiCodeCom
        },{
            id:'AcctSuppHIS',
            header: 'HIS供应商',
			allowBlank: false,
			width:200,
            dataIndex: 'AcctSuppHIS'
            
        },{
            id:'AcctSuppSubj',
            header: '财务供应商',
			allowBlank: false,
			width:200,
            dataIndex: 'AcctSuppSubj'
           
        }] 
});

//itemGrid.load({params:{start:0,limit:12}});

itemGrid.hiddenButton(3);
itemGrid.hiddenButton(4);
