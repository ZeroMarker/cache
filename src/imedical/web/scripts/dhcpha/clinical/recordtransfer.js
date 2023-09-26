Ext.QuickTips.init();
var win = Ext.getCmp("winToScetion");
if (!win) {
	var win = new Ext.Viewport(
	{
		id: 'winToScetion',
		layout: "border",
		width: 325,
		height: 450,             
			items: [{
				border:false,
				region:'north',
				layout:'fit',
				split: true,
				collapsible: true,  
				width:324,
				height: 270,
				items:gridToSection(episodeID)
			},{
				//增加转移状态 add by yang 2012-5-10
				border:false,
				region:'center',
				layout:'fit',
				split:true,
				collapsible:true,
				width:324,
				height: 180,
				items:gridStatus(episodeID)
			}]
	});
}
var body = Ext.get("gridToSection");
body.mask('读取中……', 'x-mask-loading');

function gridToSection(episodeID) {
    var sm = new Ext.grid.RowSelectionModel({ singleSelect: true});     //创建checkbox列
    var cm = new Ext.grid.ColumnModel([                  //创建grid列
        //{ header : 'ID', dataIndex : 'ID', hidden: true },
        {header: '科室名称', dataIndex: 'deptName', width: 141, sortable: false },
        {header: '进入日期', dataIndex: 'TransStartDate', width: 86, sortable: false },
        {header: '进入时间', dataIndex: 'TransStartTime', width: 86, sortable: false }
    ]);
    //cm.defaultSortable = false;          //允许排序

    var ds = new Ext.data.Store({        //创建数据源格式
		proxy: new Ext.data.HttpProxy({ url: '../EMRservice.Ajax.appointdeptmanager.cls?AppType=List&EpisodeID=' + episodeID }),     
        reader: new Ext.data.JsonReader(
        {                    
            root: 'root'                               //具体数据
        },
        [
            { name: 'deptID' },
            { name: 'deptName' },
            { name: 'TransStartDate' },
            { name: 'TransStartTime' }
        ])
    });

    ds.load();
    var tbar = new Ext.Toolbar({ border: false, items: [
         '-',
        '转出时间 ',
        { xtype: "textfield", id: "txtHourTC", width: 50, allowBlank : false, blankText: "不能为空!", regex: new RegExp("^[0-9]*[1-9][0-9]*$"), regexText: '必须是整数!' },
        ' /','小时',
        '->', '-',
        { id: 'btnConfirmTC', text: '确定', iconCls:'icon-ok',pressed: false, handler: confirm }] //huaxiaoying 2018-02-28 iconCls:'icon-ok'
    });

    function updatingToSection() {
        var body = Ext.get("gridToSection");
        body.mask('读取中……', 'x-mask-loading');
    }

    function updatedToSection() {
        var body = Ext.get("gridToSection");
		if (body != null) {
			body.unmask();
		}
    }

    ds.addListener('loadexception', function(ds, record, response){alert(response.responseText);updatedToSection();});
    ds.addListener('load', updatedToSection);

    //创建grid
    var grid = new Ext.grid.GridPanel
    ({
        id: 'gridToSection',
		title: '药历可转移至:',
        ds: ds,
        tbar: tbar,
		bbar: new Ext.Toolbar
		({
			id: 'bbarToSelect',
			height: 20
		}),
        autoScroll: true,
        cm: cm,
        sm: sm,
        frame: true
    });

    //单元格双击事件
    var celldbclick = function(grid, rowIndex, e) {
        confirm();
    }

    grid.addListener('rowdblclick', celldbclick);    

    //确认按钮的方法
    function confirm() {
        if (!Ext.getCmp('txtHourTC').isValid()) {
            return;
        }

		var hour = eval(Ext.getCmp('txtHourTC').getValue());
		if(hour>100)
		{
			var bbar = Ext.getDom('bbarToSelect');
			bbar.innerHTML = '<div style="font-weight:bold;color:Red">药历转移时间最多为100小时!</div>';
			return;
		}
	
        var grid = Ext.getCmp('gridToSection');
    	var count = grid.getSelectionModel().getCount(); 
        if (count == 0) {
            var bbar = Ext.getDom('bbarToSelect');
	    bbar.innerHTML = '<div style="font-weight:bold;color:Red">请选择一个科室!</div>';
            return;
        }
        else if (count > 1) {
            var bbar = Ext.getDom('bbarToSelect');
	    bbar.innerHTML = '<div style="font-weight:bold;color:Red">一次只能选择一个科室!</div>';
            return;
        }
	
        var grid = Ext.getCmp('gridToSection');    	

        //得到选中行的record
        for (var i = 0; i < grid.store.getCount(); i++) {
            if (grid.getSelectionModel().isSelected(i)) {
                record = grid.store.getAt(i);
                break;
            }
        }
        
        Ext.Ajax.request({
            url: '../EMRservice.Ajax.appointdeptmanager.cls',
            timeout: 5000,
            params: { EpisodeID: episodeID, AppType: 'Appoint', EMRDept: record.get('deptID'), Times: hour},
            success: function(response, opts) {
                var obj = eval(response.responseText);
                if (obj = true)
				{
					var simpleStore = Ext.getCmp('gridToSection').getStore();
					simpleStore.reload();
					var statusStore = Ext.getCmp('gridStatus').getStore();
					statusStore.reload();
				} 
				else
				{
					alert('药历转移失败!');
				}
            },
            failure: function(response, opts) {                
                var obj = response.statusText;
                alert(obj);
            }
        });	
    }
    
    function cancel()
    {
        Ext.getCmp('winToScetion').close();
    }
    
    return grid;
}

//当前的转出状态 add by yang 2012-5-10
function gridStatus(){
    var sm = new Ext.grid.RowSelectionModel({ singleSelect: true});     //创建checkbox列
    var cm = new Ext.grid.ColumnModel([                  				//创建grid列
        {header: '目前科室', dataIndex: 'emrDept', width: 141, sortable: false },
        {header: '结束日期', dataIndex: 'endDate', width: 86, sortable: false },
        {header: '结束时间', dataIndex: 'endTime', width: 86, sortable: false }
    ]);

    var ds = new Ext.data.Store({        								//创建数据源格式
		proxy: new Ext.data.HttpProxy({ url: '../EMRservice.Ajax.appointdeptmanager.cls?AppType=Status&EpisodeID=' + episodeID }),     
        reader: new Ext.data.JsonReader(
        {                    
            root: 'data'                               
        },
        [
            { name: 'emrDept' },
            { name: 'endDate' },
            { name: 'endTime' }
        ])
    });

    ds.load();
	
    var bbar = new Ext.Toolbar({ 
		border: false, 
		items: [
        	'-',
        	{ id: 'btnWithdraw', text: '收回药历',iconCls: 'icon-cancel', pressed: false, handler: withdraw }, //huaxiaoying 2018-02-28
        	'-'
        ]
    });

    function updatingToSection() {
        var body = Ext.get("gridStatus");
        body.mask('读取中……', 'x-mask-loading');
    }

    function updatedToSection() {
        var body = Ext.get("gridStatus");
		if (body != null) {
			body.unmask();
		}
    }

    ds.addListener('loadexception', function(ds, record, response){alert(response.responseText);updatedToSection();});
    ds.addListener('load', updatedToSection);

    //创建grid
    var grid = new Ext.grid.GridPanel
    ({
        id: 'gridStatus',
		title: '药历已转移至:',
        ds: ds,
        bbar: bbar,
        autoScroll: true,
        cm: cm,
        sm: sm,
        frame: true
    });

    //单元格双击事件
    //var celldbclick = function(grid, rowIndex, e) {
        //withdraw();
    //}

    //grid.addListener('rowdblclick', celldbclick);    

    //收回病历转移
    function withdraw() {

        var grid = Ext.getCmp('gridStatus');    	

        //得到选中行的record
        for (var i = 0; i < grid.store.getCount(); i++) {
            if (grid.getSelectionModel().isSelected(i)) {
                record = grid.store.getAt(i);
                break;
            }
        }
        
        Ext.Ajax.request({
            url: '../EMRservice.Ajax.appointdeptmanager.cls',
            timeout: 5000,
            params: { EpisodeID: episodeID, AppType: 'Withdraw', EpisodeID: episodeID},
            success: function(response, opts) {
                var obj = eval(response.responseText);
                if (obj = true)
				{
					var simpleStore = Ext.getCmp('gridStatus').getStore();
					simpleStore.reload();
				} 
				else
				{
					alert('收回药历失败!');
				}
            },
            failure: function(response, opts) {                
                var obj = response.statusText;
                alert(obj);
            }
        });	
    }
    return grid;	
}
