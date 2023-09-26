costUndistFun = function(deptSet, monthDr, layerDr, nodeName) {

    //============================================================面板控件=============================================================
	if(monthDr=="")
	{
		Ext.Msg.show({title:'错误',msg:'请选择核算区间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	};
    var history = new Array();
    var currentLocation = 0;
    var tmpUId = "";
    var costResultTabProxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=findUndist&monthDr=' + monthDr + '&deptSet=' + deptSet + '&layerDr=' + layerDr });
    var tmpMonth = "";
    var myAct = "";
    var itemDr = "";

    var costResultTabDs = new Ext.data.Store({
        proxy: costResultTabProxy,
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        }, [
		'rowid',
		'distedDeptDr',
		'distedDeptName',
		'distDeptDr',
		'distDeptName',
		'itemDr',
		'itemName',
		'fee',
		'distFlag',
		'dealFlag'
		]),
        remoteSort: true
    });

    costResultTabDs.setDefaultSort('distedDeptName', 'Desc');


    var costResultTabCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
		{
		    header: '被分摊部门',
		    dataIndex: 'distedDeptName', //or busItemName
		    width: 100,
		    sortable: true
		},
		{
		    header: '分摊部门',
		    dataIndex: 'distDeptName',
		    width: 100,
		    sortable: true
		},
		{
		    header: '成本项',
		    dataIndex: 'itemName',
		    width: 100,
		    sortable: true
		},
		{
		    header: '成本金额',
		    dataIndex: 'fee',
		    width: 100,
		    align: 'right',
		    renderer: formatNum,
		    sortable: true
		},
		{
		    header: '分摊标志',
		    dataIndex: 'distFlag',
		    width: 100,
		    sortable: true
		},
		{
		    header: "处理标志",
		    dataIndex: 'dealFlag',
		    width: 60,
		    sortable: true,
		    renderer: function(v, p, record) {
		        p.css += ' x-grid3-check-col-td';
		        return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		    }
		}

		]);
    var nextButton = new Ext.Toolbar.Button({
        text: '前进',
        tooltip: '前进',
        disabled: true,
        iconCls: 'add',
        handler: function() {
            backButton.enable();
            currentLocation++;
            if (currentLocation == history.length - 1) nextButton.disable();
            else nextButton.enable();
            costResultTabDs.proxy = history[currentLocation];

            costResultTabDs.load({ params: { start: 0, limit: costResultTabPagingToolbar.pageSize} });
        }
    });

    var backButton = new Ext.Toolbar.Button({
        text: '后退',
        tooltip: '后退',
        disabled: true,
        iconCls: 'add',
        handler: function() {
            currentLocation--;
            if (currentLocation == 0) backButton.disable();
            else backButton.enable();
            nextButton.enable();
            costResultTabDs.proxy = history[currentLocation];
            costResultTabDs.load({ params: { start: 0, limit: costResultTabPagingToolbar.pageSize} });
        }
    });
    //--------------------------------------------------------
    var costDistSetsSearchField = 'distDeptName';

    var costDistSetsFilterItem = new Ext.Toolbar.MenuButton({
        text: '过滤器',
        tooltip: '成本分摊套类别',
        menu: { items: [
					new Ext.menu.CheckItem({ text: '被分摊部门', value: 'distedDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
					new Ext.menu.CheckItem({ text: '分摊部门', value: 'distDeptName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
					new Ext.menu.CheckItem({ text: '成本项', value: 'itemName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
					new Ext.menu.CheckItem({ text: '分摊标志', value: 'distFlag', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
					new Ext.menu.CheckItem({ text: '处理标志', value: 'dealFlag', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
			]
        }
    });

    function onDataTypesItemCheck(item, checked) {
        if (checked) {
            costDistSetsSearchField = item.value;
            costDistSetsFilterItem.setText(item.text + ':');
        }
    };

    var costDistSetsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
        width: 180,
        trigger1Class: 'x-form-clear-trigger',
        trigger2Class: 'x-form-search-trigger',
        emptyText: '搜索...',
        listeners: {
            specialkey: { fn: function(field, e) {
                var key = e.getKey();
                if (e.ENTER === key) { this.onTrigger2Click(); } 
            } 
            }
        },
        grid: this,
        onTrigger1Click: function() {
            if (this.getValue()) {
                this.setValue('');
                costResultTabDs.proxy = new Ext.data.HttpProxy({ url: costDistSetsUrl + '?action=find&monthDr=' + monthDr + '&deptSet=' + repdr + '&deptDr=' + deptDr + '&type=dist' });
                costResultTabDs.load({ params: { start: 0, limit: costDistSetsPagingToolbar.pageSize} });
            }
        },
        onTrigger2Click: function() {
            if (this.getValue()) {
                costResultTabDs.proxy = new Ext.data.HttpProxy({
                    url: costDistSetsUrl + '?action=find&monthDr=' + monthDr + '&deptSet=' + repdr + '&deptDr=' + deptDr + '&type=dist&searchField=' + costDistSetsSearchField + '&searchValue=' + this.getValue()
                });
                costResultTabDs.load({ params: { start: 0, limit: costDistSetsPagingToolbar.pageSize} });
            }
        }
    });
    //-------------------------------------------------------

    var costResultTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
        pageSize: 15,
        store: costResultTabDs,
        displayInfo: true,
        displayMsg: '当前显示{0} - {1}，共计{2}',
        emptyMsg: "没有数据",
        buttons: ['-', costDistSetsFilterItem, '-', costDistSetsSearchBox],
        doLoad: function(C) {
            var B = {},
			A = this.paramNames;
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B['itemDr'] = itemDr;
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({ params: B });
            }
        }

    });

    //==========================================================面板==========================================================
    var formPanel = new Ext.grid.GridPanel({
        store: costResultTabDs,
        cm: costResultTabCm,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
        loadMask: true,
        //tbar: [backButton, '-', nextButton],
        bbar: costResultTabPagingToolbar
    });
    //============================================================窗口========================================================
  
    var window = new Ext.Window({
        //title: '分摊明细',
        width: 750,
        height: 500,
        minWidth: 750,
        minHeight: 500,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: formPanel,
        buttons: [
				{
				    text: '取消',
				    handler: function() { window.close(); }
		}]
    });
    costResultTabDs.load({ params: { start: 0, limit: costResultTabPagingToolbar.pageSize, type: "dist"} });
	if(nodeName==undefined)nodeName="";
	window.setTitle(nodeName+"-未分摊数据");
    window.show();

};