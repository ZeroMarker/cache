var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '是否'
});
//收录奖项等级的类型
var RewardTypelevel = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '国家级'], ['2', '省部级'], ['3', '厅局级']]
			//data : [['1', 'SCIE'], ['2', 'CSTPCD'], ['3', '其他']]
		});
var itemGrid = new dhc.herp.Grid({
        title: '奖项类别',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.rewardlevelinfoexe.csp',	  
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'Code',
            header: '奖项等级',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '奖项类别',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Name',
            store : RewardTypelevelField
            
        },{
            id:'IsValid',
            header: '是否有效',
			      //allowBlank: false,
			      editable:false,
			      width:100,
            dataIndex: 'IsValid',
            type : IsdriectField,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        }] 
});

    itemGrid.hiddenButton(3);
    itemGrid.hiddenButton(4);
