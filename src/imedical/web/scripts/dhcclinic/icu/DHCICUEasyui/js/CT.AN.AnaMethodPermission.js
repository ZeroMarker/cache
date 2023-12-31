/**
 * @author yongyang
 * @description 麻醉方法相关插管项目可见性配置
 */

var page = {
    PermissionList: [{
        text: '导管分类',
        value: 'Catheter'
    }, {
        text: '导管型号',
        value: 'CatheterType'
    }, {
        text: '插管途径',
        value: 'CatheterPath'
    }, {
        text: '插管工具',
        value: 'CatheterTool'
    }, {
        text: '插管方向',
        value: 'CatheterDirection'
    }, {
        text: '穿刺间隙',
        value: 'PunctureSpace'
    }, {
        text: '定位方法',
        value: 'PositionMethod'
    }, {
        text: '置管深度',
        value: 'CatheterDepth'
    }, {
        text: '入路',
        value: 'NerveBlockSite'
    }],
    Data: {}
}

$(document).ready(function() {
    //初始化区域
    page.listContainer = $('#permission_list');

    //设置事件处理
    setEventHandler();

    //加载数据
    loadData();
});

/**
 * 事件处理
 */
function setEventHandler() {
    $('#filterText').siblings().find('input.searchbox-text').keyup(function(e) {
        e.preventDefault();
        e.stopPropagation();
        var text = $(this).val();
        filter(text);
    });

    $('#filterText').siblings().find('.searchbox-button').click(function() {
        var text = $(this).parent().parent().find('input.searchbox-text').val();
        filter(text);
    });

    page.listContainer.delegate('.method-i-c-permission', 'click', function() {
        $(this).toggleClass('method-i-c-p-disabled');
        if ($(this).hasClass('method-i-c-p-disabled')) $(this).attr('data-value', 'H');
        else $(this).attr('data-value', 'V');
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
 * 保存数据
 */
function saveData() {
    var savingData = [];
    $.each(page.listContainer.find('.method-i'), function(i, el) {
        var method = $(el).data('data');
        if (method.AnaMethodDesc) {
            $.each($(el).find('.method-i-c-permission'), function(j, pEl) {
                var field = $(pEl).attr('data-field'),
                    value = $(pEl).attr('data-value');
                method[field] = value;
                if (value != $(pEl).attr('data-original')) changed = true;
            });
            if (changed) savingData.push(method);
        }
    });

    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestMethod,
        MethodName: "SavePermissions",
        Arg1: dhccl.formatObjects(savingData),
        ArgCnt: 1
    }, function(ret) {
        $.messager.alert('数据保存', '数据保存操作成功！');
        loadData();
    });
}

/**
 * 加载数据
 */
function loadData() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: 'FindAnaMethodPermission',
        ArgCnt: 0
    }, "json", true, function(data) {
        var container = page.listContainer;
        container.empty();

        var element;
        for (var i = 0, length = data.length; i < length; i++) {
            element = $('<div class="method-i"></div>').appendTo(container);
            itemView.render(element, data[i]);
        }
    });
}

var itemView = {
    render: function(container, item) {
        container.data('data', item);

        var header = $('<div class="method-i-header"></div>').text(item.AnaMethodDesc).appendTo(container);
        var content = $('<div class="method-i-content"></div>').appendTo(container);

        var permissionList = page.PermissionList || [];
        var permission, el;
        for (var i = 0, length = permissionList.length; i < length; i++) {
            permission = permissionList[i];
            el = $('<span class="method-i-c-permission"></span>')
                .text(permission.text)
                .attr('data-field', permission.value)
                .attr('data-original', item[permission.value])
                .attr('data-value', item[permission.value] || 'V')
                .appendTo(content);
            if (item[permission.value] == 'H') el.addClass('method-i-c-p-disabled');
        }
    }
}