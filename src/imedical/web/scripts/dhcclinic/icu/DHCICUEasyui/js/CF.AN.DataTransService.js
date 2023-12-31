/**
 * @author yongyang
 * @description 数据传输服务信息设置
 */

var page = {
    Protocols: ["WebService", "直接连接", "HTTP"],
    Systems: [],
    Services: [],
    Data: {},
    EditingService: null
}

$(document).ready(function() {
    //初始化区域
    page.listContainer = $('#service_list');

    //设置事件处理
    setEventHandler();

    //加载数据
    loadSystemList();
    loadData();
});

/**
 * 事件处理
 */
function setEventHandler() {
    $('.service-button-add').on('click', function() {
        if (!page.EditingService) addService();
    });

    page.listContainer.delegate('.service-i-edit', 'click', function() {
        var container = $(this).parent().parent();
        var service = container.data('data');
        editService(service);
    });

    $('#btnSave').click(function() {
        saveData();
    });
}

/**
 * 筛选
 */
function filter(text) {
    $.each(page.listContainer.find('.method-i'), function(i, el) {
        var data = $(el).data('data');
        if (data.AnaMethodDesc.indexOf(text) > -1) $(el).show();
        else $(el).hide();
    });
}

/**
 * 添加服务
 */
function addService() {
    var container = page.listContainer;
    page.EditingService = $('<div class="service-i"></div>').appendTo(container);
    var service = {};
    page.Services.push(service);
    serviceEditor.render(page.EditingService, service);
}

/**
 * 编辑服务
 */
function editService(service) {
    page.EditingService = service.target;
    serviceEditor.render(page.EditingService, service);
}

/**
 * 保存数据
 */
function saveData(savingData) {
    savingData = $.extend({}, savingData, {
        ClassName: 'CF.AN.DataTransService',
        target: ''
    })
    page.EditingService = null;
    var jsonData = dhccl.formatObjects([savingData]);
    dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: jsonData
    }, function(data) {
        loadData();
    });
}

/**
 * 使其有效
 */
function avtivate(rowId) {
    savingData = $.extend({}, {
        ClassName: 'CF.AN.DataTransService',
        RowId: rowId,
        Active: 'Y',
        target: ''
    });
    var jsonData = dhccl.formatObjects([savingData]);
    dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: jsonData
    }, function(data) {});
}

/**
 * 使其无效
 */
function deactivate(rowId) {
    savingData = $.extend({}, {
        ClassName: 'CF.AN.DataTransService',
        RowId: rowId,
        Active: 'N',
        target: ''
    });
    var jsonData = dhccl.formatObjects([savingData]);
    dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: jsonData
    }, function(data) {});
}

/**
 * 加载数据
 */
function loadData() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindDataTransService',
        ArgCnt: 0
    }, "json", true, function(data) {
        var container = page.listContainer;
        container.empty();

        var element;
        for (var i = 0, length = data.length; i < length; i++) {
            element = $('<div class="service-i"></div>').appendTo(container);
            serviceView.render(element, data[i]);
        }
    });
}

/**
 * 加载系统信息
 */
function loadSystemList() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindSystem',
        ArgCnt: 0
    }, "json", true, function(data) {
        page.Systems = data;
    });
}

var serviceView = {
    render: function(container, service) {
        container.data('data', service);
        container.empty();
        service.target = container;

        var header = $('<div class="service-i-header" style="display:table"></div>').appendTo(container);
        var content = $('<div class="service-i-content"></div>').appendTo(container);

        $('<b class="service-i-name" style="display:table-cell;line-height:40px;vertical-align:middle"></b>').text(service.SystemName).appendTo(header);
        $('<span class="service-i-desc" style="display:table-cell;line-height:40px;"></span>').text(service.SystemDesc).appendTo(header);
        $('<span class="service-i-vendor" style="display:table-cell;line-height:40px"></span>').text(service.SystemVendor).appendTo(header);
        $('<span class="service-i-version"></span>').text(service.Version).appendTo(header);
        $('<a href="javascript:;" class="service-i-button service-i-edit" title="编辑数据"><span class="fa fa-edit"></span></a>').appendTo(header);
        var e = $('<div class="hisui-switchbox" style="margin-left:5px"></div>').appendTo(header);
        e.switchbox({
            onText: '分库',
            offText: '共库',
            onClass: 'primary',
            offClass: 'gray',
            checked: service.Active == 'Y',
            onSwitchChange: function(e, obj) {
                if (obj.value) avtivate(service.RowId);
                else deactivate(service.RowId);
            }
        });

        var row = $('<div class="service-i-row"></div>').appendTo(content);
        $('<span class="service-i-label"></span>').text('连接方式').appendTo(row);
        $('<span class="service-i-protocol" data-value="WebService"></span>').text('WebService').appendTo(row);
        $('<span class="service-i-protocol" data-value="HTTP"></span>').text('HTTP').appendTo(row);
        $('<span class="service-i-protocol" data-value="DirectConn"></span>').text('直接连接').appendTo(row);

        content.find('.service-i-protocol[data-value="' + service.ConnectProtocol + '"]').addClass('service-i-protocol-selected');

        var row = $('<div class="service-i-row"></div>').appendTo(content);
        $('<span class="service-i-label"></span>').text('服务端地址').appendTo(row);
        $('<span class="service-i-field"></span>').text(service.ServerAddress).appendTo(row);

        var row = $('<div class="service-i-row"></div>').appendTo(content);
        $('<span class="service-i-label"></span>').text('客户端地址').appendTo(row);
        $('<span class="service-i-field"></span>').text(service.ClientAddress).appendTo(row);
    }
}

var serviceEditor = {
    render: function(container, service) {
        container.data('data', service);
        container.empty();
        service.target = container;

        var form = $('<form></form>').appendTo(container);
        $('<input type="hidden" name="RowId">').val(service.RowId || '').appendTo(form);
        var header = $('<div class="service-i-header"></div>').appendTo(form);
        var content = $('<div class="service-i-content"></div>').appendTo(form);

        var row = $('<div class="service-i-row"></div>').appendTo(header);
        $('<span class="service-i-label"></span>').text('系统').appendTo(row);
        var input = $('<input type="text" name="System" style="width:507px;">').val(service.SystemName || '').appendTo(row);
        input.combobox({
            valueField: 'RowId',
            textField: 'Name',
            required: true,
            value: service.System,
            data: page.Systems || []
        });

        var row = $('<div class="service-i-row"></div>').appendTo(header);
        $('<span class="service-i-label"></span>').text('服务版本号').appendTo(row);
        var input = $('<input type="text" class="hisui-validatebox" name="Version" style="width:500px;">').val(service.Version || '').appendTo(row);
        input.validatebox({ required: true });

        var row = $('<div class="service-i-row"></div>').appendTo(content);
        $('<span class="service-i-label"></span>').text('连接方式').appendTo(row);
        $('<input type="radio" name="ConnectProtocol" value="WebService" label="WebService">').appendTo(row);
        $('<input type="radio" name="ConnectProtocol" value="HTTP" label="HTTP" style="margin-left:10px">').appendTo(row);
        $('<input type="radio" name="ConnectProtocol" value="DirectConn" label="直接连接" style="margin-left:10px">').appendTo(row);
        row.find('input[type="radio"]').radio({});
        row.find('input[value="' + (service.ConnectProtocol || '') + '"]').radio('setValue', true);

        var row = $('<div class="service-i-row"></div>').appendTo(content);
        $('<span class="service-i-label"></span>').text('服务端地址').appendTo(row);
        var input = $('<input type="text" name="ServerAddress" class="hisui-validatebox" style="width:500px;">').val(service.ServerAddress || '').appendTo(row);
        input.validatebox({ required: true });

        var row = $('<div class="service-i-row"></div>').appendTo(content);
        $('<span class="service-i-label"></span>').text('客户端地址').appendTo(row);
        var input = $('<input type="text" name="ClientAddress" class="hisui-validatebox" style="width:500px;">').val(service.ClientAddress || '').appendTo(row);
        input.validatebox({ required: true });

        var row = $('<div class="service-i-row" style="text-align:center;padding-left:0px"></div>').appendTo(content);
        var button = $('<a href="javascript:;" class="service-i-button service-i-save">保存数据</a>').appendTo(row);
        button.linkbutton({
            title: '保存数据',
            iconCls: 'icon-w-save',
            onClick: function() {
                var container = $(this).parent().parent().parent().parent();
                var service = container.data('data');
                var form = container.find('form');
                var formData = form.serializeJson();
                $.extend(service, formData);
                saveData(service);
            }
        });

        form.form({});
    }
}