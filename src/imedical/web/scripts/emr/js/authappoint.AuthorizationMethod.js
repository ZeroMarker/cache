//变量声明********************************************
var url = '../EMRservice.Ajax.AuthAppoint.cls';

var eprIntegratedAuthorization = '1' //表明是综合授权
var defaultAppointType = '0'; //个人 0-个人，1-科室
var defaultAppointSpan = '168'; //168小时(1周)
var defaultAppointRequestSpan = '0'; //无
var defaultAppointAction = 'getunappointed'; //getall-获取全部未授权已授权，getrefuse-获取已拒绝，getunappointed-获取未授权
var defaultCanAppoint = '2'; //0-无权限,1-可授权,2-全部
var defaultPageSize = 20;

//申请起止时间
var dtRequestDateStart = "";
var tmRequestTimeStart = "";
var dtRequestDateEnd = "";
var tmRequestTimeEnd = "";
//授权起止时间
var dtAppointDateStart = "";
var tmAppointTimeStart = "";
var dtAppointDateEnd = "";
var tmAppointTimeEnd = "";

var canAppointSelect = "";
var treatmentLoc = "";
var requestLoc = "";
var requestUserName = "";

var PapmiNo = ""; //add by niucaicai 2013-03-13 按登记号查询
var MedicareNo = ""; //add by niucaicai 2015-10-08 按病案号查询
var PatName = "";  //add by niucaicai 2016-11-04 按患者姓名查询
var pAAdmType = "";
var pAStatus = "";

var pageSize = defaultPageSize;
var appointSpan = defaultAppointSpan;
var appointType = defaultAppointType;
var appointRequestSpan = defaultAppointRequestSpan;

var chkCurLoc = false; //true为勾选中本科授权
var chkCurLocDis = true;
if (onlyCurrentDept == "1") {
    chkCurLoc = true;
}
else {
    chkCurLoc = false;
}

var globalRequestRange = "";
var AuthLevelType = "";

//功能函数********************************************
//QuickTips
Ext.QuickTips.init();
//表格列按中文汉语拼音排序
Ext.data.Store.prototype.applySort = function(){
    if (this.sortInfo && !this.remoteSort) {
        var s = this.sortInfo;
        var f = s.field;
        var st = this.fields.get(f).sortType;
        var fn = function(r1, r2){
            var v1 = st(r1.data[f]);
            v2 = st(r2.data[f]);
            if (typeof(v1) == "string") {
                return v1.localeCompare(v2);
            }
            return v1 > v2 ? 1 : (v1 < v2 ? -1 : 0);
        };
        this.data.sort(s.direction, fn);
        if (this.snapshot && this.snapshot != this.data) {
            this.snapshot.sort(s.direction, fn);
        }
    }
};

//checkbox列
Ext.grid.CheckColumn = function(config){
    Ext.apply(this, config);
    if (!this.id) {
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype = {
    init: function(grid){
        this.grid = grid;
        this.grid.on('render', function(){
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },
    
    onMouseDown: function(e, t){
        if (t.className && t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
            e.stopEvent();
            var index = this.grid.getView().findRowIndex(t);
            var record = this.grid.store.getAt(index);
            var cindex = this.grid.getView().findCellIndex(t);
            var record = this.grid.store.getAt(index);
            var field = this.grid.colModel.getDataIndex(cindex);
            var value = !record.data[this.dataIndex];
            record.set(this.dataIndex, !record.data[this.dataIndex]);
            
            //事件的参数  
            var e = {
                grid: this.grid,
                record: record,
                field: field,
                originalValue: record.data[this.dataIndex],
                value: !record.data[this.dataIndex],
                row: index,
                column: cindex
            };
            
            //<span style="color: #ff0000;">afterEdit事件</span>   
            this.grid.fireEvent("afteredit", e); //申请事件，参数    
        }
    },
    
    renderer: function(v, p, record){
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col' + (v ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
    }
};

//右键菜单*********************************************
//Desc: 弹出病历浏览
function goEMRBrowse(grid, rowindex, e) {
    //debugger;
    var record = grid.getStore().getAt(rowindex);
    var episodeID = record.get("EpisodeID");

    var win = new Ext.Window({
        id: 'winBrowse',
        layout: 'fit', 	//自动适应Window大小 
        title: '电子病历浏览',
        frame: true,
        width: 950,
        height: 600,
        shim: false,    
        animCollapse: false,
        constrainHeader: true,
        resizable: true,
        modal: true,
        maximizable: true,
        raggable: true, //不可拖动
        items: [{
		    html: '<iframe id="eprWrite" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="emr.interface.browse.episode.csp?EpisodeID=' + episodeID + '"></iframe>'
		}]
    });
    win.show();
}

function rightClickFn(grid, rowindex, e) {
    //debugger;
    e.preventDefault();
    
    if (rowindex < 0) { return; }
    
    var menus = new Ext.menu.Menu({
        id: 'mnuContext',
        items: [
        {
            id: 'menuEPRBrowse',
            text: '病历浏览',
            pressed: true,
            icon: '../scripts/epr/Pics/browser.gif',
            handler: function() { 
				goEMRBrowse(grid, rowindex, e); 
			}
        }]
    });

    menus.showAt(e.getPoint());
}

//下拉框选项********************************************
//科室
var loc = "";
if (typeof(Ext.getCmp('cbxTreatmentLoc')) != "undefined" && Ext.getCmp('cbxTreatmentLoc').getValue() != "") {
    loc = Ext.getCmp('cbxTreatmentLoc').getRawValue();
}
var getLocStore = new Ext.data.JsonStore({
    url: '../web.eprajax.StdDictionaryInfo.cls',
    fields: ['ID', 'DicCode', 'DicDesc', 'DicAlias'],
    listeners: {
        'beforeload': function(){
            loc = Ext.getCmp("cbxTreatmentLoc").getRawValue();
            getLocStore.baseParams = {
                Type: 'getloc',
                Param: loc
            };
        }
    }
});

var requestLoc = "";
if (typeof(Ext.getCmp('cbxRequestLoc')) != "undefined" && Ext.getCmp('cbxRequestLoc').getValue() != "") {
    requestLoc = Ext.getCmp('cbxRequestLoc').getValue();
}
var getRequestLocStore = new Ext.data.JsonStore({
    url: '../web.eprajax.StdDictionaryInfo.cls',
    fields: ['ID', 'DicCode', 'DicDesc', 'DicAlias'],
    listeners: {
        'beforeload': function(){
            requestLoc = Ext.getCmp("cbxRequestLoc").getRawValue();
            getRequestLocStore.baseParams = {
                Type: 'getloc',
                Param: requestLoc
            };
        }
    }
});

var getRequestRangeStore = new Ext.data.JsonStore({
    url: '../web.eprajax.StdDictionaryInfo.cls',
    root: 'Data',
    totalProperty: 'TotalCount',
    fields: [{
        name: 'ID'
    }, {
        name: 'Desc'
    }]
});

//转换********************************************
//转换操作代码为操作名称
function getAction(val){
    var retStr = "";
    switch (val) {
        case 'save':
            retStr = '保存';
            break;
        case 'print':
            retStr = '打印';
            break;
		case 'delete':
            retStr = '删除';
            break;
        case 'reference':
            retStr = '文档对照';
            break;
        case 'export':
            retStr = '导出文档';
            break;
        case 'residentcheck':
            retStr = '住院医师审核';
            break;
        case 'chiefcheck':
            retStr = '主任医师审核';
            break;
        case 'attendingcheck':
            retStr = '主治医师审核';
            break;
        case 'view':
            retStr = '查看';
            break;
		case 'new':
            retStr = '创建';
            break;
		case 'copypaste':
            retStr = '复制粘贴';
            break;
        default:
            retStr = val;
    }
    return retStr;
}

//转换授权类型码为名称
function getAppointType(val){
    if (val == "" || typeof(val) == "undefined") {
        return;
    }
    var retStr = "";
    switch (val) {
        case '0':
            retStr = '个人';
            break;
        case '1':
            retStr = '科室';
            break;
        default:
            retStr = val;
    }
    return retStr;
}

//选中授权申请记录是否已经被审核过
function CheckAppointed(val){
    if (val == 'appointed' || val == 'refuse') {
        return true;
    }
    return false;
}

//是否可以审核指定授权级别的记录
function CheckAuthLevel(val) {
    if (authLevelTop >= val) {
        return true;
    } else {
        return false;
    }
}

//对申请范围/授权范围的描述进行解析  add by niucaicai 2016-5-10
function getCateCharpterDesc(val) {
	val = TrimEnterAndWrite(val)
	var resultStr = "";
	var ccDescStr = val.split("^");
	for (i=0;i<ccDescStr.length ;i++ )
	{
		var ccDesc = ccDescStr[i];
		var ccDescSub = ccDesc.split(".");
		var ccDescSubStr = "";
		if (ccDescSub.length > 1)
		{
			ccDescSubStr = ccDescSub[1];
		}
		else
		{
			ccDescSubStr = ccDescSub[0];
		} 
		if (resultStr == "")
		{
			resultStr = ccDescSubStr;
		}
		else
		{
			resultStr = resultStr + "," + ccDescSubStr;
		}
	}
	return resultStr;
}

function TrimEnterAndWrite(val)
{
	while (val.indexOf("xiegangxiegang")!= -1)
	{
		val = val.replace("xiegangxiegang","\\");
	}
	while (val.indexOf("@@@")!= -1)
	{
		val = val.replace("@@@","'");
	}
	while (val.indexOf("fanxiegangfanxiegang")!= -1)
	{
		val = val.replace("fanxiegangfanxiegang","/");
	}
	while (val.indexOf("douhaodouhao")!= -1)
	{
		val = val.replace("douhaodouhao",",");
	}
	while (val.indexOf("tanhaotanhao")!= -1)
	{
		val = val.replace("tanhaotanhao","!");
	}
	while (val.indexOf("juhaojuhao")!= -1)
	{
		val = val.replace("juhaojuhao","。");
	}
	while (val.indexOf("zuodanyinhao")!= -1)
	{
		val = val.replace("zuodanyinhao","‘");
	}
	while (val.indexOf("youdanyinhao")!= -1)
	{
		val = val.replace("youdanyinhao","’");
	}
	while (val.indexOf(" ")!= -1)
	{
		val = val.replace(" ","");
	}

	return val;
}

function getActionByCode(val)
{
	var retStr = "";
    switch (val) {
        case 'S':
            retStr = '保存';
            break;
        case 'P':
            retStr = '打印';
            break;
		case 'D':
            retStr = '删除';
            break;
        case 'V':
            retStr = '查看';
            break;
		case 'N':
            retStr = '创建';
            break;
        default:
            retStr = val;
    }
    return retStr;
}

function rendererRequestAction(val)
{
	var actionStr = "";
	var detailObj = val.split('#');
	for (var i = 0; i < detailObj.length; i++) {
		var IDActionStatusStr = detailObj[i].split('^');
		var actionDesc = getActionByCode(IDActionStatusStr[1]);
		if (actionStr == "")
		{
			actionStr = actionDesc;
		}
		else
		{
			actionStr = actionStr + "," + actionDesc;
		}
	}
	return actionStr;
}

function rendererAppointAction(val)
{
	var actionStr = "";
	var detailObj = val.split('#');
	for (var i = 0; i < detailObj.length; i++) {
		var IDActionStatusStr = detailObj[i].split('^');
		if (IDActionStatusStr[2] == "1")
		{
			var actionDesc = getActionByCode(IDActionStatusStr[1]);
			if (actionStr == "")
			{
				actionStr = actionDesc;
			}
			else
			{
				actionStr = actionStr + "," + actionDesc;
			}
		}
	}
	return actionStr;
}

//渲染********************************************
//转换能否审核码为名称，并上色
function rendererCanAppoint(val){
    var retStr = "";
    if (val == '2') {
        retStr = '已授权';
        return retStr;
    }
    else 
        if (val == '0') {
            retStr = "<span style='color:red;font-weight:bold;'>无权限</span>";
            return retStr;
        }
        else 
            if (val == '1') {
                retStr = "<span style='color:green;font-weight:bold;'>可授权</span>";
                return retStr;
            }
            else 
                if (val == '3') {
                    retStr = '拒绝';
                    return retStr;
                }
                else {
                    retStr = val;
                    return retStr;
                }
}

//转换授权状态为名称，并上色
function rendererIsAppointed(val){
    var retStr = "";
    if (val == 'unappointed') {
        retStr = '未授权';
        return retStr;
    }
    else 
        if (val == 'appointed') {
            retStr = '已授权';
            //已授权改变背景色
            retStr = "<span style='color:red;font-weight:bold;'>已授权</span>";
            return retStr;
        }
        else 
            if (val == 'refuse') {
                retStr = '拒绝';
                return retStr;
            }
            else {
                retStr = val;
                return retStr;
            }
}

//给予授权时间
function rendererAppointSpan(val){
    if (val == "" || typeof(val) == "undefined") {
        return;
    }
    val = parseFloat(val);
    val = parseInt(val)
	if (val==168)
	{
		return '1周';
	}
	else
	{
		return val + '小时';
	}
}

//授权时间
function rendererAppointDateTime(val){
    if (val == "" || typeof(val) == "undefined") {
        return;
    }
    else {
        if (val == "1840-12-31 00:00:00") {
            return "";
        }
        else {
            return val;
        }
    }
}

function rendererPAAdmType(val){
    var retStr = "";
    if (val == 'I') {
        retStr = '住院';
        return retStr;
    }
    else 
        if (val == 'O') {
            retStr = '门诊';
            return retStr;
        }
        else {
            retStr = '急诊';
            return retStr;
        }
}

function rendererPAStatus(val){
    var retStr = "";
    if (val == 'in') {
        retStr = '在院';
        return retStr;
    }
    else {
        retStr = "<span style='color:green;font-weight:bold;'>出院</span>";
        return retStr;
    }
}

function rendererPADischgeDateTime(val){
    if (val == "" || typeof(val) == "undefined") {
        return;
    }
    else {
        if (val == "1840-12-31 00:00:00") {
            return "";
        }
        else {
            return val;
        }
    }
}

function rendererIsActive(val){
    var retStr = "";
    if (val == 1) {
        retStr = "<span style='color:green;font-weight:bold;'>授权中</span>";
        return retStr;
    }
    else 
        if (val == 0) {
            retStr = '过期';
            return retStr;
        }
        else {
            return ""
        }
}

function IsSealed(val)
{
	var retStr = "";
	
	var HasSealedFlag = HasSealed(val);
	if (HasSealedFlag == 'Y') {
        retStr = "<span style='color:red;font-weight:bold;'>有</span>";
    }else if (HasSealedFlag == 'N') {
        retStr = "<span style='color:green;font-weight:bold;'>无</span>";
    }
    return retStr;
}

function HasSealed(val)
{
	var HasSealed = "N";
    for (var i = 0; i < val.length; i++) {
        if (val[i].IsSealed == "Y")
        {
            HasSealed = "Y";
			break;
        }
    }
	
	return HasSealed;
}

function getSealedRecordTitles(val)
{
	var retStr = "";
    for (var i = 0; i < val.length; i++) {
        if (val[i].IsSealed == "Y")
        {
            if (retStr == "")
			{
				retStr = val[i].CCDesc;
			}
			else
			{
				retStr = retStr + "<br>" + val[i].CCDesc;
			}
        }
    }
	
	return retStr;
}

function rendererSealed(val){
	var retStr = "";
    if (val == 'Y') {
        retStr = "<span style='color:red;font-weight:bold;'>是</span>";
    }else if (val == 'N') {
        retStr = '否';
    }else{
        retStr = val;
    }
    return retStr;
}

//改变已授权行和无权限行背景色
function changeRowBackgroundColor(grid){
    var store = grid.getStore(grid);
    var total = store.getCount();
    for (var i = 0; i < total; i++) {
        //若已经进行了授权,改变其背景色
        var isAppointed = CheckAppointed(store.getAt(i).data['IsAppointed']);
        if (isAppointed) {
            grid.getView().getRow(i).style.backgroundColor = '#AAAAAA';
        }
        else {
			if (store.getAt(i).data['CanAppoint'] == '0' || CheckAuthLevel(store.getAt(i).data['AuthLevel']) == false)
			{
                grid.getView().getRow(i).style.backgroundColor = '#99bbe8';
            }
            var appointSpanIndex = grid.getColumnModel().findColumnIndex("AppointSpan");
            grid.getView().getCell(i, appointSpanIndex).style.color = 'green';
            var appointTypeIndex = grid.getColumnModel().findColumnIndex("AppointType");
            grid.getView().getCell(i, appointTypeIndex).style.color = 'green';
			/*
            var actionTypeIndex = grid.getColumnModel().findColumnIndex("ActionType");
            grid.getView().getCell(i, actionTypeIndex).style.color = 'green';
			*/
        }
    }
}

//表格事件定义**********************************************
//处理授权申请列表单击事件
function gridRowClick(g, index, e){
	//alert("gridRowClick");
	//清空 fsRange 和 fsReason
	if (Ext.getCmp('fsRange') != null & typeof(Ext.getCmp('fsRange')) != "undefined") {
		detailProperty.remove(Ext.getCmp('fsRange'), true);
	}
	if (Ext.getCmp('fsReason') != null & typeof(Ext.getCmp('fsReason')) != "undefined") {
		detailProperty.remove(Ext.getCmp('fsReason'), true);
	}
	var fsReason = getFSReason();
	detailProperty.add(fsReason);
	//DisableParent = 0;
    //获取选中授权申请记录信息
    var record = g.getStore().getAt(index);

    var requestReason = record.data['RequestReason'];
	requestReason = TrimEnterAndWrite(requestReason);
    Ext.getCmp('taRequestReason').setValue(requestReason);

    var beforeRequestContent = record.data['BeforeRequestContent'];
    beforeRequestContent = TrimEnterAndWrite(beforeRequestContent);
    Ext.getCmp('taBeforeRequestContent').setValue(beforeRequestContent);

    var afterRequestContent = record.data['AfterRequestContent'];
    afterRequestContent = TrimEnterAndWrite(afterRequestContent);
    Ext.getCmp('taAfterRequestContent').setValue(afterRequestContent);
    
    var requestNumber = record.data['RequestNumber'];
    requestNumber = TrimEnterAndWrite(requestNumber);
    Ext.getCmp('taRequestNumber').setValue(requestNumber)

	detailProperty.doLayout();
}

function expanderGridRowClick(g, index, e){
	//alert("expanderGridRowClick");
	//清空 fsRange 和 fsReason
	if (Ext.getCmp('fsRange') != null & typeof(Ext.getCmp('fsRange')) != "undefined") {
		detailProperty.remove(Ext.getCmp('fsRange'), true);
	}
	if (Ext.getCmp('fsReason') != null & typeof(Ext.getCmp('fsReason')) != "undefined") {
		detailProperty.remove(Ext.getCmp('fsReason'), true);
	}
	var fsRange = getFSRange();
	detailProperty.add(fsRange);
	//获取当前选择的父表条目index、子表条目index
	var CurrExpanderGridID = g.id;
	var gridIndex = CurrExpanderGridID.substring(12,CurrExpanderGridID.length);
	var expanderGridIndex = index;
	
	DisableParent = 1;
    //获取选中申请模板的信息
    var record = g.getStore().getAt(index);
    var DetailStr = record.data['DetailStr'];
	var isAppointed = record.data['IsAppointed'];
	var canAppoint = record.data['CanAppoint'];
    var IsSealed = record.data['IsSealed'];
    
    if (IsSealed == "Y")
    {
        Ext.MessageBox.alert("简单提示", "不能对已封存病历进行授权.");
		return;
    }
	//alert(isAppointed);
	//alert(canAppoint);
    //重新初始化fsRange
    if (Ext.getCmp('fsRange') != null & typeof(Ext.getCmp('fsRange')) != "undefined") {
        detailProperty.remove(Ext.getCmp('fsRange'), true);
    }
    var fsRange = getFSRange();
    detailProperty.insert(0,fsRange);

    //为fsRange添加操作类型
	var detailObj = DetailStr.split('#');
	for (var i = 0; i < detailObj.length; i++) {
		var IDActionStatusStr = detailObj[i].split('^');
		var actionDesc = getActionByCode(IDActionStatusStr[1]);
		//alert(IDActionStatusStr[2]);
        var checkbox = new Ext.form.Checkbox();
        checkbox.id = IDActionStatusStr[0];
        checkbox.boxLabel = actionDesc;
        checkbox.labelSeparator = '';
        checkbox.hideLabel = true;
		if (IDActionStatusStr[2] == "0")
		{
			checkbox.checked = false;
		}
		else
		{
			checkbox.checked = true;
		}

        fsRange.add(checkbox);
    }

	//条目未授权,并且当前用户能够授权,并且没有对操作类型做出过修改的，需要选中，并可以操作；
	if ((isAppointed == "unappointed")&&(canAppoint == "1"))
	{
		var noUpdateActions = true;
		for (var i = 0; i < detailObj.length; i++) {
			var IDActionStatusStr = detailObj[i].split('^');
			var detailStatus = IDActionStatusStr[2]
			if (detailStatus == "1")
			{
				noUpdateActions = false;
			}
		}
		if (noUpdateActions)
		{
			for (var i = 0; i < fsRange.items.items.length; i++) {
				fsRange.items.items[i].checked = true;
			}
		}

		//处理更改申请操作类型
		var btnUpdateFsRange = new Ext.Button({
			id: 'btnUpdateFsRange',
			name: 'btnUpdateFsRange',
			text: '修改申请操作',
			handler: function(){
				var appointActions = "";
				for (var i = 0; i < fsRange.items.items.length; i++) {
					if (fsRange.items.items[i].id == "btnUpdateFsRange")
					{
						continue;
					}
					else
					{
						if (fsRange.items.items[i].checked)
						{
							if (appointActions == "") {
								appointActions = fsRange.items.items[i].id + "^1";
							}
							else {
								appointActions = appointActions + '#' + fsRange.items.items[i].id + "^1";
							}
						}
						else
						{
							if (appointActions == "") {
								appointActions = fsRange.items.items[i].id + "^0";
							}
							else {
								appointActions = appointActions + '#' + fsRange.items.items[i].id + "^0";
							}
						}
					}
				}
				//alert(appointActions);
				Ext.Ajax.request({
					url: url,
					timeout: 5000,
					params: {
						Action: "updatefs",
						AppointActions: appointActions
					},
					success: function(response, opts){
						//alert(response.responseText);
						if (response.responseText = "1") {
							//alert(gridIndex);
							//alert(expanderGridIndex);
							var link = getUrl();
							var grid = Ext.getCmp('dgResultGrid')
							var s = grid.getStore();
							s.proxy.conn.url = link;
							s.load({
								callback: function(){
									expander.toggleRow(gridIndex);
									//grid.getSelectionModel().selectRow(gridIndex);
									//grid.getView().focusRow(gridIndex);
								}
							});
						}
						else {
							Ext.MessageBox.alert('操作提示', '更改权限范围操作失败');
						}
					},
					failure: function(response, opts){
						Ext.MessageBox.alert("提示", response.responseText);
					}
				});
			}
		});
		
		fsRange.add(btnUpdateFsRange);
	}
	//条目已授权或者已拒绝
	else
	{
		for (var i = 0; i < fsRange.items.items.length; i++) {
            fsRange.items.items[i].setDisabled(true);
        }
	}
    detailProperty.doLayout();
    
}

//处理点击表头排序后授权行改色和数据加载
function gridHeaderClick(g, columnId, e){
	alert("aaa");
	alert(columnId);
	alert(g.id);
    if (columnId != 0) {
        changeRowBackgroundColor(g)
		/*
        g.getStore().load({
            params: {
                start: 0,
                limit: pageSize
            }
        });
		*/
    }
    else {
        //第0列checkbox列，不变
        ;
    }
}

function expanderGridHeaderClick(g, columnId, e){
	alert("bbb");
	alert(columnId);
	alert(g.id);
    if (columnId != 0) {
        //changeRowBackgroundColor(g)
		/*
        g.getStore().load({
            params: {
                start: 0,
                limit: pageSize
            }
        });
		*/
    }
    else {
        //第0列checkbox列，不变
        ;
    }
}

//右侧属性**********************************************
//属性中申请范围
function getFSRange(){

    var field = new Ext.form.FieldSet({
        id: 'fsRange',
        labelWidth: 0,
        title: '申请操作',
        collapsible: true,
        autoHeight: true,
        width: 250,
        defaultType: 'checkbox'
    });
    return field;
}

//属性中申请原因
function getFSReason(){

    var field = new Ext.form.FieldSet({
        id: 'fsReason',
        labelWidth: 0,
        title: '申请原因',
        collapsible: true,
        autoHeight: true,
        width: 250,
        labelAlign: 'top',
        labelWidth: 200,
        items: [{
            xtype: 'textarea',
            id: 'taRequestReason',
            fieldLabel: '申请的原因',
            enable: false,
            readOnly: true,
            style: 'border:0px;background:#dfe8f6',
            grow: true,
            preventScrollbars: true,
            allowBank: false,
            width: 200,
            height: 35,
            maxLength: 1000
        }, {
            xtype: 'textarea',
            id: 'taBeforeRequestContent',
            fieldLabel: '修改前内容',
            enable: false,
            readOnly: true,
            style: 'border:0px;background:#dfe8f6',
            grow: true,
            preventScrollbars: true,
            allowBank: false,
            width: 200,
            height: 35,
            maxLength: 1000
        }, {
            xtype: 'textarea',
            id: 'taAfterRequestContent',
            fieldLabel: '修改后内容',
            enable: false,
            readOnly: true,
            style: 'border:0px;background:#dfe8f6',
            grow: true,
            preventScrollbars: true,
            allowBank: false,
            width: 200,
            height: 35,
            maxLength: 1000
        },{
            xtype: 'textarea',
            id: 'taRequestNumber',
            fieldLabel: '申请人电话',
            enable: false,
            readOnly: true,
            style: 'border:0px;background:#dfe8f6',
            grow: true,
            preventScrollbars: true,
            allowBank: false,
            width: 200,
            height: 35,
            maxLength: 1000
        }]
    });
    return field;
}

function setCateChapterInfo(requestCC, requestCCDesc, appointCC, isAppointed, ID, index, canAppoint){
    //重新初始化fsRange
    if (Ext.getCmp('fsRange') != null & typeof(Ext.getCmp('fsRange')) != "undefined") {
        detailProperty.remove(Ext.getCmp('fsRange'), true);
    }
    var fsRange = getFSRange();
    detailProperty.insert(0,fsRange);
    
    //为fsRange添加申请范围
    var aryCCId = requestCC.split('^');
    var aryCCDesc = requestCCDesc.split('^');
    for (var i = 0; i < aryCCId.length; i++) {
        var checkbox = new Ext.form.Checkbox();
        checkbox.id = aryCCId[i];
        checkbox.boxLabel = aryCCDesc[i];
        checkbox.labelSeparator = '';
        checkbox.hideLabel = true;
        
        fsRange.add(checkbox);
    }
    
    if (isAppointed) {
        var tmp = "^" + appointCC + "^";
        //只选中fsRange申请范围中被审核的项目
        for (var i = 0; i < fsRange.items.items.length; i++) {
            if (tmp.indexOf('^' + fsRange.items.items[i].id + '^') != -1) {
                fsRange.items.items[i].setValue(true);
            }
            fsRange.items.items[i].setDisabled(true);
        }
    }
    else {
        if (canAppoint == '0') {
            for (var i = 0; i < fsRange.items.items.length; i++) {
                fsRange.items.items[i].setValue(true);
                fsRange.items.items[i].setDisabled(true);
            }
        }
        else {
            if (appointCC == "") {
                //选中fsRange申请范围所有项目
                for (var i = 0; i < fsRange.items.items.length; i++) {
                    fsRange.items.items[i].setValue(true);
                }
            }
            else {
                var tmp = "^" + appointCC + "^";
                //只选中fsRange申请范围中被审核的项目
                for (var i = 0; i < fsRange.items.items.length; i++) {
                    if (tmp.indexOf('^' + fsRange.items.items[i].id + '^') != -1) {
                        fsRange.items.items[i].setValue(true);
                    }
                }
            }
            
            //处理更改申请范围
            var btnUpdateFsRange = new Ext.Button({
                id: 'btnUpdateFsRange',
                name: 'btnUpdateFsRange',
                text: '确认修改申请范围',
                handler: function(){
                    var count = 0;
                    var appointCateCharpter = "";
                    for (var i = 0; i < fsRange.items.items.length; i++) {
                        if (fsRange.items.items[i].checked) {
                            if (count == 0) {
                                appointCateCharpter = fsRange.items.items[i].id;
                            }
                            else {
                                appointCateCharpter = appointCateCharpter + '^' + fsRange.items.items[i].id;
                            }
                            count++;
                        }
                    }
                    
                    Ext.Ajax.request({
                        url: url,
                        timeout: 5000,
                        params: {
                            Action: "updatefs",
                            ID: ID,
                            AppointCateCharpter: appointCateCharpter
                        },
                        success: function(response, opts){
                            if (response.responseText = "1") {
								alert("sss");
                                var link = getUrl();
                                var grid = Ext.getCmp('dgResultGrid')
                                var s = grid.getStore();
                                s.proxy.conn.url = link;
                                s.load({
                                    callback: function(){
										expander.toggleRow(index);
                                        //grid.getSelectionModel().selectRow(index);
                                        //grid.getView().focusRow(index);
                                    }
                                });
                            }
                            else {
                                Ext.MessageBox.alert('操作提示', '更改权限范围操作失败');
                            }
                        },
                        failure: function(response, opts){
                            Ext.MessageBox.alert("提示", response.responseText);
                        }
                    });
                }
            });
            
            fsRange.add(btnUpdateFsRange);
        }
    }
    detailProperty.doLayout();
}

//表单提交**********************************************
//获取带参数url
function getUrl(){
    //获取登记号   add by niucaicai 2013-03-13
    if (typeof(Ext.getCmp('txtPapmiNo')) == "undefined" || Ext.getCmp('txtPapmiNo').getValue() == "") {
        PapmiNo = "";
    }
    else {
        PapmiNo = Ext.getCmp('txtPapmiNo').getValue();
		//登记号补全十位
		var ncont = 10-PapmiNo.length;
        for (var i = 0; i < ncont; i++)
        {
	        PapmiNo = '0'+PapmiNo;
	    }
	    Ext.getCmp('txtPapmiNo').setValue(PapmiNo);
    }
    
	//获取病案号，供病案室用户查询使用   add by niucaicai 2015-10-08
    if (typeof(Ext.getCmp('MedicareNo')) == "undefined" || Ext.getCmp('MedicareNo').getValue() == "") {
        MedicareNo = "";
    }
    else {
        MedicareNo = Ext.getCmp('MedicareNo').getValue();
    }
	
	//获取患者姓名   add by niucaicai 2016-11-04
    if (typeof(Ext.getCmp('textName')) == "undefined" || Ext.getCmp('textName').getValue() == "") {
        PatName = "";
    }
    else {
        PatName = Ext.getCmp('textName').getValue();
    }

    //获取就诊科室
    if (typeof(Ext.getCmp('cbxTreatmentLoc')) == "undefined" || Ext.getCmp('cbxTreatmentLoc').getValue() == "" || Ext.getCmp('cbxTreatmentLoc').getRawValue() == "") {
        treatmentLoc = "";
    }
    else {
        treatmentLoc = Ext.getCmp('cbxTreatmentLoc').getValue();
    }
    
    //获取就诊类型
    if (typeof(Ext.getCmp('cbxPAAdmType')) == "undefined" || Ext.getCmp('cbxPAAdmType').getValue() == "") {
        pAAdmType = "";
    }
    else {
        pAAdmType = Ext.getCmp('cbxPAAdmType').getValue();
    }
    
    //获取在院状态
    if (typeof(Ext.getCmp('cbxPAStatus')) == "undefined" || Ext.getCmp('cbxPAStatus').getValue() == "") {
        pAStatus = "";
    }
    else {
        pAStatus = Ext.getCmp('cbxPAStatus').getValue();
    }
    
    //获取申请科室
    if (typeof(Ext.getCmp('cbxRequestLoc')) == "undefined" || Ext.getCmp('cbxRequestLoc').getValue() == "" || Ext.getCmp('cbxRequestLoc').getRawValue() == "") {
        requestLoc = "";
    }
    else {
        requestLoc = Ext.getCmp('cbxRequestLoc').getValue();
    }
    
    //获取申请医生
    if (typeof(Ext.getCmp('txtRequestUserName')) == "undefined" || Ext.getCmp('txtRequestUserName').getValue() == "") {
        requestUserName = "";
    }
    else {
        requestUserName = Ext.getCmp('txtRequestUserName').getValue();
    }
    
    //获取action
    var cbxAppointActionCmp = Ext.getCmp('cbxAppointAction');
    if (typeof(cbxAppointActionCmp) == "undefined" || cbxAppointActionCmp.getValue() == "") {
        action = defaultAppointAction;
    }
    else {
        action = cbxAppointActionCmp.getValue();
    }
    //将action赋给授权情况下拉框
    Ext.getCmp('cbxAppointAction').setValue(action);

	//获取授权级别
    var cbxAuthLevelCmp = Ext.getCmp('cbxAuthLevel');
    if (typeof(cbxAuthLevelCmp) == "undefined" || cbxAuthLevelCmp.getValue() == "") {
        AuthLevelType = authLevelTop;
		Ext.getCmp('cbxAuthLevel').setValue(AuthLevelType);
    }
    else {
        AuthLevelType = cbxAuthLevelCmp.getValue();
	}
    
    //获取申请起止时间，默认为空
    if (typeof(Ext.getCmp('dtRequestDateStart')) == "undefined" || Ext.getCmp('dtRequestDateStart').getValue() == "") {
        dtRequestDateStart = "";
    }
    else {
        dtRequestDateStart = Ext.getCmp('dtRequestDateStart').getValue().format('Y-m-d');
    }
    if (typeof(Ext.getCmp('tmRequestTimeStart')) == "undefined" || Ext.getCmp('tmRequestTimeStart').getValue() == "") {
        tmRequestTimeStart = "";
    }
    else {
        tmRequestTimeStart = Ext.getCmp('tmRequestTimeStart').getValue();
    }
    if (typeof(Ext.getCmp('dtRequestDateEnd')) == "undefined" || Ext.getCmp('dtRequestDateEnd').getValue() == "") {
        dtRequestDateEnd = "";
    }
    else {
        dtRequestDateEnd = Ext.getCmp('dtRequestDateEnd').getValue().format('Y-m-d');
    }
    if (typeof(Ext.getCmp('tmRequestTimeEnd')) == "undefined" || Ext.getCmp('tmRequestTimeEnd').getValue() == "") {
        tmRequestTimeEnd = "";
    }
    else {
        tmRequestTimeEnd = Ext.getCmp('tmRequestTimeEnd').getValue();
    }
    
    //获取授权起止时间，默认为空，若授权时间有值，则action改为getappointed
    if (typeof(Ext.getCmp('dtAppointDateStart')) == "undefined" || Ext.getCmp('dtAppointDateStart').getValue() == "") {
        dtAppointDateStart = "";
    }
    else {
        dtAppointDateStart = Ext.getCmp('dtAppointDateStart').getValue().format('Y-m-d');
    }
    if (typeof(Ext.getCmp('tmAppointTimeStart')) == "undefined" || Ext.getCmp('tmAppointTimeStart').getValue() == "") {
        tmAppointTimeStart = "";
    }
    else {
        tmAppointTimeStart = Ext.getCmp('tmAppointTimeStart').getValue();
    }
    if (typeof(Ext.getCmp('dtAppointDateEnd')) == "undefined" || Ext.getCmp('dtAppointDateEnd').getValue() == "") {
        dtAppointDateEnd = "";
    }
    else {
        dtAppointDateEnd = Ext.getCmp('dtAppointDateEnd').getValue().format('Y-m-d');
    }
    if (typeof(Ext.getCmp('tmAppointTimeEnd')) == "undefined" || Ext.getCmp('tmAppointTimeEnd').getValue() == "") {
        tmAppointTimeEnd = "";
    }
    else {
        tmAppointTimeEnd = Ext.getCmp('tmAppointTimeEnd').getValue();
    }

	//起止日期/授权起止日期/申请起止时间/授权起止时间 必须成对出现
	var isUseRequestDate = (dtRequestDateStart != ""&&dtRequestDateEnd != "")||(dtRequestDateStart == "" && dtRequestDateEnd == "");
	var isUseAppointDate = (dtAppointDateStart != ""&&dtAppointDateEnd != "")||(dtAppointDateStart == "" && dtAppointDateEnd == "");
	var isUseRequestTime = (tmRequestTimeStart != ""&&tmRequestTimeEnd != "")||(tmRequestTimeStart == "" && tmRequestTimeEnd == "");
	var isUseAppointTime = (tmAppointTimeStart != ""&&tmAppointTimeEnd != "")||(tmAppointTimeStart == "" && tmAppointTimeEnd == "");
	if (!(isUseRequestDate && isUseAppointDate && isUseRequestTime && isUseAppointTime)) {
		alert("申请起止日期/授权起止日期/申请起止时间/授权起止时间 必须成对出现!");
		return "";
	}
    
    //获取授权权限
    var cbxCanAppointCmp = Ext.getCmp('cbxCanAppoint');
    //只有未授权的情况下才能给予授权
    if (action == 'getunappointed') {
        cbxCanAppointCmp.setDisabled(false);
        if (typeof(cbxCanAppointCmp) == "undefined" || cbxCanAppointCmp.getValue() == "") {
            canAppointSelect = defaultCanAppoint;
        }
        else {
            canAppointSelect = cbxCanAppointCmp.getValue();
            Ext.getCmp('cbxAppointAction').setValue(action);
        }
        Ext.getCmp('cbxCanAppoint').setValue(canAppointSelect);
    }
    else {
        //已授权和全部禁用获取权限下拉框
        cbxCanAppointCmp.setDisabled(true);
    }
    
    //授权当前是否有效
    var isActive = Ext.getCmp('cbxIsActive').getValue();
    
    if (action == "getunappointed") {
        Ext.getCmp('dtAppointDateStart').setDisabled(true);
        Ext.getCmp('dtAppointDateEnd').setDisabled(true);
    }
    else {
        Ext.getCmp('dtRequestDateStart').setDisabled(true);
        Ext.getCmp('dtRequestDateEnd').setDisabled(true);
    }
    
    //拼url
    var PAADM = '&PAAdmType=' + pAAdmType + '&PAStatus=' + pAStatus + '&PapmiNo=' + PapmiNo + '&MedicareNo=' + MedicareNo + '&PatName=' + escape(PatName); //modify by niucaicai 2013-03-13
    var DefaultString = '&DefaultAppointSpan=' + appointSpan + '&DefaultAppointType=' + appointType + '&AppointRequestSpan=' + appointRequestSpan;
    var RequestTimeString = '&RequestDateStart=' + dtRequestDateStart + '&RequestTimeStart=' + tmRequestTimeStart + '&RequestDateEnd=' + dtRequestDateEnd + '&RequestTimeEnd=' + tmRequestTimeEnd;
    var AppointTimeString = '&AppointDateStart=' + dtAppointDateStart + '&AppointTimeStart=' + tmAppointTimeStart + '&AppointDateEnd=' + dtAppointDateEnd + '&AppointTimeEnd=' + tmAppointTimeEnd;
    var link = url + '?Action=' + action + '&OnlyCurrentDept=' + onlyCurrentDept + '&EPRIntegratedAuthorization=' + eprIntegratedAuthorization + '&CanAppointSelect=' + canAppointSelect + '&IsActive=' + isActive + '&TreatmentLoc=' + treatmentLoc + '&RequestLoc=' + requestLoc + '&RequestUserName=' + encodeURI(requestUserName) + DefaultString + RequestTimeString + AppointTimeString + PAADM;
    link = link + '&RequestRange=' + globalRequestRange + '&AuthLevelType=' + AuthLevelType;
	return link;
}

//查询
function getAppointList(){
    var link = getUrl();
	if (link == "")
	{
		// 若 起止日期/授权起止日期/申请起止时间/授权起止时间 没有成对出现时,会返回空;
		return;
	}
    var s = Ext.getCmp('dgResultGrid').getStore();
    s.proxy.conn.url = link;
    s.load({
        params: {
            start: 0,
            limit: pageSize
        }
    });
}

//重置
function queryReset(){
    Ext.getCmp('txtPapmiNo').setValue(""); //add by niucaicai 2013-03-13
    Ext.getCmp('cbxTreatmentLoc').setValue("");
    Ext.getCmp('cbxAppointAction').setValue("");
    Ext.getCmp('cbxCanAppoint').setValue("");
    Ext.getCmp('cbxIsActive').setValue("");
    Ext.getCmp('cbxRequestLoc').setValue("");
    Ext.getCmp('cbxPAStatus').setValue("");
    Ext.getCmp('cbxPAAdmType').setValue("");
    Ext.getCmp('cbxCanAppoint').disable(true);
    Ext.getCmp('cbxIsActive').disable(true);
    Ext.getCmp('dtRequestDateStart').setValue("");
    Ext.getCmp('tmRequestTimeStart').setValue("");
    Ext.getCmp('tmRequestTimeStart').setVisible(false);
    Ext.getCmp('dtRequestDateEnd').setValue("");
    Ext.getCmp('tmRequestTimeEnd').setValue("");
    Ext.getCmp('tmRequestTimeEnd').setVisible(false);
    Ext.getCmp('txtRequestUserName').setValue("");
    Ext.getCmp('dtAppointDateStart').setValue("");
    Ext.getCmp('tmAppointTimeStart').setValue("");
    Ext.getCmp('tmAppointTimeStart').setVisible(false);
    Ext.getCmp('dtAppointDateEnd').setValue("");
    Ext.getCmp('tmAppointTimeEnd').setValue("");
    Ext.getCmp('tmAppointTimeEnd').setVisible(false);
    //Ext.getCmp('cbxRangeTree').setValue("");
    globalRequestRange = "";
	/*
    var nodes = Ext.getCmp('comboTree').getChecked();
    if (nodes && nodes.length) {
        for (var i = 0; i < nodes.length; i++) {
            //设置UI状态为未选中状态 
            nodes[i].getUI().toggleCheck(false);
            //设置节点属性为未选中状态 
            nodes[i].attributes.checked = false;
        }
    }
	*/
}

function resetProperty(){
    //重新初始化右边栏属性的值为空
    /*Ext.getCmp('lblRequestDate').setValue("");
    Ext.getCmp('lblRequestTime').setValue("");
    Ext.getCmp('lblRequestUser').setValue("");
    Ext.getCmp('lblRequestDept').setValue("");
    Ext.getCmp('lblActionType').setValue("");
    Ext.getCmp('lblAppointDate').setValue("");
    Ext.getCmp('lblAppointTime').setValue("");
    Ext.getCmp('lblAppointUser').setValue("");
    Ext.getCmp('lblAppointType').setValue("");
    Ext.getCmp('lblAppointSpan').setValue("");*/
    
    //重新初始化fsRange
    if (Ext.getCmp('fsRange') != null & typeof(Ext.getCmp('fsRange')) != "undefined") {
        detailProperty.remove(Ext.getCmp('fsRange'), true);
    }
    var fsRange = getFSRange();
    detailProperty.add(fsRange);
}

//审批
function commitAppoint(){
	var grid = Ext.getCmp('dgResultGrid');
	//如果有选中的，展开，选中全部申请项目
	var selections = grid.getSelectionModel().getSelections();
	//alert(selections.length);
	if (selections.length > 0)
	{
		for (var i = 0; i < selections.length; i++) {
			var row = selections[i];
			
			//ID
			var AppointID = row.get('AppointID');
			
			//授权类型                      
			var appointType = row.get('AppointType');
			if (appointType == "") {
				//授权类型没填，则取默认
				appointType = defaultAppointType;
			}
			
			//授权时长		    
			var span = row.get('AppointSpan');
			if (span == "" || isNaN(span)) {
				//授权时长没填，则取默认
				span = defaultAppointSpan;
			}
			var appointSpan = 3600 * parseFloat(span).toString();
			
			//ajax
			Ext.Ajax.request({
				url: url,
				timeout: 5000,
				params: {
					Action: "appoint",
					AppointID: AppointID,
					AppointSpan: appointSpan,
					AppointUserID: appointUserID,
					AppointType: appointType
				},
				success: function(response, opts){
					//debugger;
					if (response.responseText == "1") {
						//授权操作成功，更新待授权列表
						var link = getUrl();
						var s = Ext.getCmp('dgResultGrid').getStore();
						s.proxy.conn.url = link;
						s.load({
							params: {
								start: 0,
								limit: pageSize
							}
						});
					}
					else {
						Ext.MessageBox.alert('操作提示', '申请权限操作提交失败');
					}
				},
				failure: function(response, opts){
					Ext.MessageBox.alert("提示", response.responseText);
				}
			});
		}
	}
	else
	{
		Ext.MessageBox.alert('操作提示', '请选中一条记录再提交申请');
		return;
	}
	
    resetProperty();
}

//拒绝
function refuseAppoint(){
	//var grid = Ext.getCmp('dgResultGrid');
    //var selectedRows = grid.getSelectionModel().getSelections();
	var seletedCount = 0;
	var successCount = 0;
    var grid = Ext.getCmp('dgResultGrid');
    var store = grid.getStore();
    var total = store.getCount();
	//如果有选中的，展开，选中全部申请项目
	var selections = grid.getSelectionModel().getSelections();
	if (selections.length > 0)
	{
		var RefuseReason = "";
		Ext.MessageBox.show({
			title: "拒绝原因",
			msg: "请填写拒绝原因:",
			buttons: {ok:"确定",cancel:"取消"},
			width: 400,
			closable: false,
			multiline: true,
			fn: function(JJOnlybtn,text){
				if (JJOnlybtn == "ok")
				{
					RefuseReason = text;
					//alert(selections.length);
					for (var i = 0; i < selections.length; i++) {
						var row = selections[i];
						var AppointID = row.get('AppointID');
						
						//ajax
						Ext.Ajax.request({
							url: url,
							timeout: 5000,
							params: {
								Action: "refuse",
								AppointID: AppointID,
								AppointUserID: appointUserID,
								RefuseReason: RefuseReason
							},
							success: function(response, opts){
								//debugger;
								if (response.responseText == "1") {
									//授权操作成功，更新待授权列表
									var link = getUrl();
									var s = Ext.getCmp('dgResultGrid').getStore();
									s.proxy.conn.url = link;
									s.load({
										params: {
											start: 0,
											limit: pageSize
										}
									});
								}
								else {
									Ext.MessageBox.alert('操作提示', '拒绝权限操作提交失败');
								}
							},
							failure: function(response, opts){
								Ext.MessageBox.alert("提示", response.responseText);
							}
						});
					}
				}
				else
				{
					return;
				}
			}
		});
	}
	else
	{
		Ext.MessageBox.alert('操作提示', '请选中一条记录再提交申请');
		return;
	}
	
    resetProperty();
	
}

function withdrawAppoint(){
    var grid = Ext.getCmp('dgResultGrid');
    var store = grid.getStore();
    var total = store.getCount();
	for (var i = 0; i < total; i++) {
		if (store.getAt(i).data['AppointWithdraw'] == true) {
			//ID
			var AppointID = store.getAt(i).data['AppointID'];
			
			//ajax
			Ext.Ajax.request({
				url: url,
				timeout: 5000,
				params: {
					Action: "withdraw",
					AppointID: AppointID
				},
				success: function(response, opts){
					//debugger;
					if (response.responseText == "1") {
						//授权操作成功，更新待授权列表
						var link = getUrl();
						var s = Ext.getCmp('dgResultGrid').getStore();
						s.proxy.conn.url = link;
						s.load({
							params: {
								start: 0,
								limit: pageSize
							}
						});
					}
					else {
						Ext.MessageBox.alert('操作提示', '撤销权限操作提交失败');
					}
				},
				failure: function(response, opts){
					Ext.MessageBox.alert("提示", response.responseText);
				}
			});
		}
    }
    resetProperty();
}

//add by niucaicai 导出数据方法 -------------------------------------start
function doExport(grid, Flag){
    try {
        //debugger;
        var xls = new ActiveXObject("Excel.Application");
        xls.visible = true; //设置excel为可见    
        var xlBook = xls.Workbooks.Add;
        var xlSheet = xlBook.Worksheets(1);
        xlSheet.name = grid.name;
		//显示方式改为分组显示，修改导出功能
        //var cm = grid.getColumnModel();
		var store = grid.getStore();
		var total = store.getCount();
		if (total == 0)
		{
			return;
		}
		//显示方式改为分组显示，修改导出功能，主表和子表的列分别加载
		//加载主表列数据
		var cm = grid.getColumnModel();
		var colCount = cm.getColumnCount();
        var temp_obj = [];
        //只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示)    
        //临时数组,存放所有当前显示列的下标    
		//从i等于2开始循环，过滤掉前面的“+”列和“CheckBox”列
        for (i = 2; i < colCount; i++) {
            if (cm.getColumnHeader(i) == "" || cm.isHidden(i) == true) {
                //不下载CheckBox列和隐藏列  
            }
            else {
                temp_obj.push(i);
            }
        }
		
        for (i = 1; i <= temp_obj.length; i++) {
            //显示列的列标题    
			//alert("i:"+i);
			//alert("value:"+cm.getColumnHeader(temp_obj[i - 1]));
            xlSheet.Cells(1, i).Value = cm.getColumnHeader(temp_obj[i - 1]);
            xlSheet.Cells(1, i).Interior.ColorIndex = 15;
            xlSheet.Cells(1, i).Font.Bold = true;
            //设置导出的列格式，解决字符串在导出到excel中变成数值型
			//显示方式改为分组显示，修改导出功能
            //var fld = grid.getStore().recordType.prototype.fields.get(cm.getDataIndex(i));
			//getDataIndex从2开始循环，过滤掉前面的“+”列和“CheckBox”列
			/*
			var fld = grid.getStore().recordType.prototype.fields.get(cm.getDataIndex(temp_obj[i - 1]));
            if (fld.type == "auto") {
				xlSheet.Columns(i).NumberFormatLocal = "@";
            }
			*/
			xlSheet.Columns(i).NumberFormatLocal = "@";
        }
		//加载子表列数据
		for (var j = 0; j < total; j++) {
			expander.toggleRow(j);
		}
		var expanderGrid = Ext.getCmp("expanderGrid0");
		if ((expanderGrid == undefined)||(expanderGrid == "undefined")||(expanderGrid == "null")||(expanderGrid == "NULL")||(expanderGrid == ""))
		{
			return;
		}

		var expanderCM = expanderGrid.getColumnModel();
		var expanderCMCount = expanderCM.getColumnCount();
        var temp_expanderopObj = [];
        
        //只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示)    
        //临时数组,存放所有当前显示列的下标    
        for (i = 1; i < expanderCMCount; i++) {
            if (expanderCM.getColumnHeader(i) == "" || expanderCM.isHidden(i) == true) {
                //不下载CheckBox列和隐藏列  
            }
            else {
                temp_expanderopObj.push(i);
            }
        }
        for (i = 1, j = temp_obj.length + 1 ; i <= temp_expanderopObj.length; i++, j++) {
            //显示列的列标题    
            xlSheet.Cells(1, j).Value = expanderCM.getColumnHeader(temp_expanderopObj[i - 1]);
            xlSheet.Cells(1, j).Interior.ColorIndex = 15;
            xlSheet.Cells(1, j).Font.Bold = true;
            //设置导出的列格式，解决字符串在导出到excel中变成数值型
			/*
			var fld = expanderGrid.getStore().recordType.prototype.fields.get(expanderCM.getDataIndex(temp_expanderopObj[i - 1]));
            if (fld.type == "auto") {
                xlSheet.Columns(j).NumberFormatLocal = "@";
            }
			*/
			xlSheet.Columns(j).NumberFormatLocal = "@";
        }
		
        var RowNum = 2;
        if (Flag == 1) {
            ExportCurrentPage(grid, xlSheet, temp_obj, temp_expanderopObj, xlBook, xls, RowNum)
        }
        else {
            var k = 0;
            //屏蔽导出过程中可能引起 grid 变化的按钮（授权选中条目、提前收回选中授权、查询）
            Ext.getCmp("btnCommit").disabled = true;
            Ext.getCmp("btnWithdraw").disabled = true;
            Ext.getCmp("btnAppointQuery").disabled = true;
            ExportAllPage(grid, xlSheet, temp_obj, temp_expanderopObj, xlBook, xls, k, RowNum)
        }
        
    } 
    catch (e) {
        //alert("要打印该表，您必须安装Excel电子表格软件，同时浏览器须使用“ActiveX 控件”，您的浏览器须允许执行控件。 请点击【帮助】了解浏览器设置方法！");
        Ext.Msg.show({
            title: '提示',
            msg: '1、请先确定已安装Microsoft Excel；2、请设置IE的菜单\'工具\'->Internet选项->安全->自定义级别->\'对没有标记为可安全执行脚本ActiveX控件初始化并执行脚本\'->选择[启用]&nbsp;&nbsp;就可以生成Excel',
            buttons: Ext.Msg.OK,
            icon: Ext.Msg.INFO
        });
    }
}

//导出当前页数据
function ExportCurrentPage(grid, xlSheet, temp_obj, temp_expanderopObj, xlBook, xls, RowNum){
    var store = grid.getStore();
    var recordCount = store.getCount();
    if (recordCount > 0) {
		//显示方式改为分组显示，修改导出功能
		var view = grid.getView();
		for (m = 0; m < recordCount ; m++)
		{
			var expanderGridID = "expanderGrid" + m;
			var expanderGrid = Ext.getCmp(expanderGridID);
			var expanderStore = expanderGrid.getStore();
			var expanderRecCount = expanderStore.getCount();
			if (expanderRecCount > 0)
			{
				var expanderView = expanderGrid.getView();
				for (i = 1; i <= expanderRecCount; i++) {
					for (j = 1; j <= temp_obj.length; j++) {
						xlSheet.Cells(RowNum, j).Value = view.getCell(m, temp_obj[j - 1]).innerText;
					}
					for (n = temp_obj.length + 1, j = 1; n <= temp_obj.length + temp_expanderopObj.length; n++, j++) {
						xlSheet.Cells(RowNum, n).Value = expanderView.getCell(i - 1, temp_expanderopObj[j - 1]).innerText;
					}
					RowNum = RowNum + 1;
				}
			}
		}
    }
    xlSheet.Columns.AutoFit;
    xls.ActiveWindow.Zoom = 100;
    xls.UserControl = true; //很重要,不能省略,不然会出问题 意思是excel交由用户控制
    xls = null;
    xlBook = null;
    xlSheet = null;
	//显示方式改为分组显示，修改导出功能
	getAppointList();
}

//导出所有数据
function ExportAllPage(grid, xlSheet, temp_obj, temp_expanderopObj, xlBook, xls, k, RowNum){
    var gstore = grid.getStore();
    gstore.load({
        //分页加载数据
        params: {
            start: k * pageSize,
            limit: pageSize
        },
        callback: function(r, options, success){
            var recordCount = gstore.getCount();
            //判断当前页是否有数据，若有则导出，并进行下一页；若无则说明最后一页已经导出完毕，返回第一页数据；
            if (recordCount == 0) {
                //恢复导出过程中被屏蔽掉的按钮（）
                Ext.getCmp("btnCommit").disabled = false;
                Ext.getCmp("btnWithdraw").disabled = false;
                Ext.getCmp("btnAppointQuery").disabled = false;
                gstore.load({
                    params: {
                        start: 0,
                        limit: pageSize
                    }
                });
                return;
            }
            else {
                //显示方式改为分组显示，修改导出功能
				var view = grid.getView();
				for (m = 0; m < recordCount; m++) {
					expander.toggleRow(m);
					var expanderGridID = "expanderGrid" + m;
					var expanderGrid = Ext.getCmp(expanderGridID);
					var expanderStore = expanderGrid.getStore();
					var expanderRecCount = expanderStore.getCount();
					if (expanderRecCount > 0)
					{
						var expanderView = expanderGrid.getView();
						for (i = 1; i <= expanderRecCount; i++) {
							for (j = 1; j <= temp_obj.length; j++) {
								xlSheet.Cells(RowNum, j).Value = view.getCell(m, temp_obj[j - 1]).innerText;
							}
							for (n = temp_obj.length + 1, j = 1; n <= temp_obj.length + temp_expanderopObj.length; n++, j++) {
								xlSheet.Cells(RowNum, n).Value = expanderView.getCell(i - 1, temp_expanderopObj[j - 1]).innerText;
							}
							RowNum = RowNum + 1;
						}
					}
				}
				
                k = k + 1;
                //递归调用方法本身，进行下一页数据的导出
                ExportAllPage(grid, xlSheet, temp_obj, temp_expanderopObj, xlBook, xls, k, RowNum);
                xlSheet.Columns.AutoFit;
                xls.ActiveWindow.Zoom = 100;
                xls.UserControl = true; //很重要,不能省略,不然会出问题 意思是excel交由用户控制
                xls = null;
                xlBook = null;
                xlSheet = null;
            }
        },
        scope: gstore
    });
}

//add by niucaicai 导出数据方法 -------------------------------------end
function isIE(){
	var userAgent = navigator.userAgent, 
	rMsie = /(msie\s|trident.*rv:)([\w.]+)/; 
	var browser; 
	var version; 
	var ua = userAgent.toLowerCase(); 
	function uaMatch(ua){ 
		var match = rMsie.exec(ua); 
		if(match != null){ 
			return { browser : "IE", version : match[2] || "0" }; 
		}
	} 
	var browserMatch = uaMatch(userAgent.toLowerCase()); 
	if (browserMatch.browser){ 
		browser = browserMatch.browser; 
		version = browserMatch.version; 
	} 
	return(browser+version);
}
