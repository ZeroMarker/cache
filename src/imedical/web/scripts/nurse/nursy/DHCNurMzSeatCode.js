/**
 * @author Qse
 */
var dataset = new Array();
var locdata = new Array();
var loc = session['LOGON.CTLOCID'];
cspRunServerMethod(getloc, 'addloc');
cspRunServerMethod(GetSeatCode, loc, 'add');
////locdes),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"','"_$ZCVT($g(code),"O","JS")_"','"_$ZCVT($g(seatsize),"O","JS")_"','"_$ZCVT($g(seatpoint),"O","JS")_"','"_$ZCVT($g(loc),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"


function add(a, b, c, d, e, f, g, h) {
    dataset.push({
        locdes: a,
        des: b,
        code: c,
        seatsize: d,
        seatpoint: e,
        loc: f,
        flag: h,
        id: g
    });
}

function addloc(a, b) {
    locdata.push({
        loc: a,
        locdes: b
    });
}

function getstore(dep) {
    cspRunServerMethod(GetSeatCode, dep, 'add');

}

function find(dep) {
    dataset = new Array();
    getstore(dep);
    //store.data=datatest;
    //alert(datatest[1].toString());
    grid.store.loadData(dataset);
}

var store = new Ext.data.JsonStore({
    data: dataset,
    fields: ["id", "locdes", "des", "code", "seatsize", "seatpoint", "loc", "flag"]
});

var colM = new Ext.grid.ColumnModel([{
        header: "id",
        dataIndex: "id",
        hidden: true
    },

    {
        header: "科室",
        dataIndex: "locdes",
        sortable: true
    },

    {
        header: "座位代码",
        dataIndex: "code"
    }, {
        header: "座位名称",
        dataIndex: "des"
    }, {
        header: "尺寸",
        dataIndex: "seatsize",
        sortable: true
    }, {
        header: "位置",
        dataIndex: "seatpoint",
        sortable: true
    }, {
        header: "标志",
        dataIndex: "flag",
        sortable: true
    }, {
        header: "loc",
        dataIndex: "loc",
        hidden: true
    }
]);

var storeloc = new Ext.data.JsonStore({
    data: locdata,
    fields: ['loc', 'locdes']
});
var LocSearchField = 'name';
/*
var LocFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: {
        items: [new Ext.menu.CheckItem({
            text: '科室',
            value: 'loc',
            checked: false,
            group: 'LocFilter',
            checkHandler: onLocItemCheck})]   }
});
*/
function onLocItemCheck(item, checked) {
    if (checked) {
        LocSearchField = item.value;
        LocFilterItem.setText(item.text + ':');
    }
};

var LocSearchBox = new Ext.form.ComboBox({
    store: storeloc,
    displayField: 'locdes', //store字段中你要显示的字段，多字段必选参数，默认当mode为remote时displayField为undefine，当select列表时displayField为"text"
    hiddenName: 'loc',
    valueField: 'loc',
    mode: 'local', //因为data已经取数据到本地了，所以'local',默认为"remote"，枚举完
    emptyText: '请选择一个科室...',
	listeners: {
			focus: {
				fn: function (e) {
					e.expand();
					this.doQuery(this.allQuery, true);
				},
				buffer: 200
			},
			beforequery: function (e) {
				// 在文本框内输入拼音时，根据store内code进行过滤，在下拉列表中只显示拼音匹配的选项
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
					combo.store.filterBy(function (record, id) {
						var text = getPinyin(record.get('locdes'));
						return regExp.test(text) | regExp.test(record.data[me.displayField])
					});
					combo.expand();
					combo.select(0, true);// 将光标默认指向下拉列表的第一项，这样在取到合适的选项时，通过上下方向键和回车就可以选中需要的结果
					return false;
				}
			}
		}

});
LocSearchBox.on('select', function() {
    find(Ext.get("loc").dom.value);
    var lnk = "dhcnursyseatmap.csp?&loc=" + Ext.get("loc").dom.value;
    parent.frames['RPbottom'].location.href = lnk;


});
var LocTabPagingToolbar = new Ext.Toolbar({ //分页工具栏
    //buttons: [LocFilterItem, '-', LocSearchBox]
    items: ['-', LocSearchBox]
});

var addLocButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip: '添加',
	icon:'../images/uiimages/edit_add.png',
    handler: function() {
        AddFun(storeloc);
    }
});
var editLocButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip: '修改',
	icon:'../images/uiimages/pencil.png',
    handler: function() {
        EditFun(grid);
    }
});

var generateSeat = new Ext.Toolbar.Button({
    text: '批量生成',
    tooltip: '批量生成',
	icon:'../images/uiimages/update1.png',
    handler: function() {
        generateFun(storeloc);
    }
});
var pwidth = document.body.clientWidth;
var pheight = document.body.clientHeight;
var grid = new Ext.grid.GridPanel({

    renderTo: "hello",

    title: "输液室座位维护",

    height: pheight,

    width: pwidth,

    cm: colM,

    store: store,

    autoExpandColumn: 2,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({
        singleSelect: true
    }),
    loadMask: true,
    tbar: ['-', addLocButton, '-', editLocButton, '-', generateSeat],
    bbar: LocTabPagingToolbar
});