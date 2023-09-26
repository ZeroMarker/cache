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
				//����ת��״̬ add by yang 2012-5-10
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
body.mask('��ȡ�С���', 'x-mask-loading');

function gridToSection(episodeID) {
    var sm = new Ext.grid.RowSelectionModel({ singleSelect: true});     //����checkbox��
    var cm = new Ext.grid.ColumnModel([                  //����grid��
        //{ header : 'ID', dataIndex : 'ID', hidden: true },
        {header: '��������', dataIndex: 'deptName', width: 141, sortable: false },
        {header: '��������', dataIndex: 'TransStartDate', width: 86, sortable: false },
        {header: '����ʱ��', dataIndex: 'TransStartTime', width: 86, sortable: false }
    ]);
    //cm.defaultSortable = false;          //��������

    var ds = new Ext.data.Store({        //��������Դ��ʽ
		proxy: new Ext.data.HttpProxy({ url: '../EMRservice.Ajax.appointdeptmanager.cls?AppType=List&EpisodeID=' + episodeID }),     
        reader: new Ext.data.JsonReader(
        {                    
            root: 'root'                               //��������
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
        'ת��ʱ�� ',
        { xtype: "textfield", id: "txtHourTC", width: 50, allowBlank : false, blankText: "����Ϊ��!", regex: new RegExp("^[0-9]*[1-9][0-9]*$"), regexText: '����������!' },
        ' /','Сʱ',
        '->', '-',
        { id: 'btnConfirmTC', text: 'ȷ��', iconCls:'icon-ok',pressed: false, handler: confirm }] //huaxiaoying 2018-02-28 iconCls:'icon-ok'
    });

    function updatingToSection() {
        var body = Ext.get("gridToSection");
        body.mask('��ȡ�С���', 'x-mask-loading');
    }

    function updatedToSection() {
        var body = Ext.get("gridToSection");
		if (body != null) {
			body.unmask();
		}
    }

    ds.addListener('loadexception', function(ds, record, response){alert(response.responseText);updatedToSection();});
    ds.addListener('load', updatedToSection);

    //����grid
    var grid = new Ext.grid.GridPanel
    ({
        id: 'gridToSection',
		title: 'ҩ����ת����:',
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

    //��Ԫ��˫���¼�
    var celldbclick = function(grid, rowIndex, e) {
        confirm();
    }

    grid.addListener('rowdblclick', celldbclick);    

    //ȷ�ϰ�ť�ķ���
    function confirm() {
        if (!Ext.getCmp('txtHourTC').isValid()) {
            return;
        }

		var hour = eval(Ext.getCmp('txtHourTC').getValue());
		if(hour>100)
		{
			var bbar = Ext.getDom('bbarToSelect');
			bbar.innerHTML = '<div style="font-weight:bold;color:Red">ҩ��ת��ʱ�����Ϊ100Сʱ!</div>';
			return;
		}
	
        var grid = Ext.getCmp('gridToSection');
    	var count = grid.getSelectionModel().getCount(); 
        if (count == 0) {
            var bbar = Ext.getDom('bbarToSelect');
	    bbar.innerHTML = '<div style="font-weight:bold;color:Red">��ѡ��һ������!</div>';
            return;
        }
        else if (count > 1) {
            var bbar = Ext.getDom('bbarToSelect');
	    bbar.innerHTML = '<div style="font-weight:bold;color:Red">һ��ֻ��ѡ��һ������!</div>';
            return;
        }
	
        var grid = Ext.getCmp('gridToSection');    	

        //�õ�ѡ���е�record
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
					alert('ҩ��ת��ʧ��!');
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

//��ǰ��ת��״̬ add by yang 2012-5-10
function gridStatus(){
    var sm = new Ext.grid.RowSelectionModel({ singleSelect: true});     //����checkbox��
    var cm = new Ext.grid.ColumnModel([                  				//����grid��
        {header: 'Ŀǰ����', dataIndex: 'emrDept', width: 141, sortable: false },
        {header: '��������', dataIndex: 'endDate', width: 86, sortable: false },
        {header: '����ʱ��', dataIndex: 'endTime', width: 86, sortable: false }
    ]);

    var ds = new Ext.data.Store({        								//��������Դ��ʽ
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
        	{ id: 'btnWithdraw', text: '�ջ�ҩ��',iconCls: 'icon-cancel', pressed: false, handler: withdraw }, //huaxiaoying 2018-02-28
        	'-'
        ]
    });

    function updatingToSection() {
        var body = Ext.get("gridStatus");
        body.mask('��ȡ�С���', 'x-mask-loading');
    }

    function updatedToSection() {
        var body = Ext.get("gridStatus");
		if (body != null) {
			body.unmask();
		}
    }

    ds.addListener('loadexception', function(ds, record, response){alert(response.responseText);updatedToSection();});
    ds.addListener('load', updatedToSection);

    //����grid
    var grid = new Ext.grid.GridPanel
    ({
        id: 'gridStatus',
		title: 'ҩ����ת����:',
        ds: ds,
        bbar: bbar,
        autoScroll: true,
        cm: cm,
        sm: sm,
        frame: true
    });

    //��Ԫ��˫���¼�
    //var celldbclick = function(grid, rowIndex, e) {
        //withdraw();
    //}

    //grid.addListener('rowdblclick', celldbclick);    

    //�ջز���ת��
    function withdraw() {

        var grid = Ext.getCmp('gridStatus');    	

        //�õ�ѡ���е�record
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
					alert('�ջ�ҩ��ʧ��!');
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
