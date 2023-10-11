var hospid = session['LOGON.HOSPID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';

//////////////////医疗单位////////////////////
var AddCompDRDs = new Ext.data.Store({
						proxy : "",
						url : commonboxUrl+'?action=hospital&rowid='+hospid+'&start=0&limit=10&str=',
						//autoLoad : true,  
						fields: ['rowid','name'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});

			AddCompDRDs.on('load', function() {

						var Num=AddCompDRDs.getCount();
    					if (Num!=0){
						var id=AddCompDRDs.getAt(0).get('rowid');
						AddCompDRCombo.setValue(id);  
    					} 
					});

			var AddCompDRCombo = new Ext.form.ComboBox({
						id : 'AddCompDRCombo',
						name : 'AddCompDRCombo',
						fieldLabel : '医疗单位',
						store : AddCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						allowBlank: false,
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 70,
						listWidth : 300,
						pageSize : 10,
						minChars : 1,
						anchor: '90%',
						selectOnFocus : true
					});	


//IP
var conIPField = new Ext.form.TextField({
	width:200,
	columnWidth : .12,
	editable:true
});
//描述
var conDescField = new Ext.form.TextField({	
	width:200,
	columnWidth : .12,
	editable:true
});
//编码
var conCodeField = new Ext.form.TextField({
	width : 70,
	columnWidth : .12,
	selectOnFocus : true
});

// 主页面查询
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls:'option',
			handler : function() {
			
				var IP = conIPField.getValue();
				var Desc = conDescField.getValue();
				var Code = conCodeField.getValue();

				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								Code : Code,
								IP : IP,
								Desc : Desc
							}
						});

			}
			
		})
		
var itemGrid = new dhc.herp.Grid({
        title: '配置信息维护',
        width: 400,
        //edit:false,                   //是否可编辑
        //readerModel:'local',
        region: 'center',
        url: 'herp.budg.budgconfigexe.csp',
		tbar:['配置编码','-',conCodeField,'配置描述','-',conDescField,'配置地址','-',conIPField,'-',findButton],
		atLoad : true, // 是否自动刷新 Code ^ IP ^ Desc
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edits:false,
            hidden: true
        }, {
            id:'CompName',
            header: '医疗单位',
			calunit:true,
			allowBlank: true,
			width:120,
			hidden: true,
            dataIndex: 'CompName',
			type:AddCompDRCombo
        },{
            id:'Code',
            header: '配置项编码',
			allowBlank: false,
			width:120,
            dataIndex: 'Code'
        },{
            id:'IP',
            header: '配置地址',
			allowBlank: false,
			width:120,
            dataIndex: 'IP'
        },{
            id:'Desc',
            header: '描述',
			allowBlank: false,
			width:200,
            dataIndex: 'Desc'
        },{
            id:'Desc1',
            header: '用户名',
			width:180,
            dataIndex: 'Desc1'
        },{
            id:'Desc2',
            header: '用户密码',
			width:180,
            dataIndex: 'Desc2'
        },{
            id:'Desc3',
            header: '文件夹',
			width:180,
            dataIndex: 'Desc3'
        },{
            id:'Desc4',
            header: '其他4',
			width:180,
			hidden:true,
            dataIndex: 'Desc4'
        }]
    
    });

	itemGrid.btnResetHide();
	itemGrid.btnPrintHide();
