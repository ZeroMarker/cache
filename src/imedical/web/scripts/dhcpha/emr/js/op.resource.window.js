function setTabs() {
    //debugger;
    var insID = invoker.envVar.docContext.InstanceID;
    var secCode = invoker.emrEditor.SectionCode;
    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetOPSectionRes', insID, secCode);
    ajaxGETSync(data, function (ret) {
        try {
            if ('' === ret) {
                $('#resTabs').tabs('select', 0);
            } else {
                ret = $.parseJSON(ret);
                var tab = $('#resTabs').tabs('getSelected');
                if (!tab || ret.Title !== tab.panel('options').Title) {
                    $('#resTabs').tabs('select', ret.Title);
                }
            }
        } catch (e) {
            alert(e);
        }
    }, function (err) {
        alert('GetOPSectionRes error:' + err);
    });
}

function getTabs() {
    function addTab(_id, _title, _selected, _frame, _content, _href) {
        _content = replaceLinkParams(_content);
        if (isExistVar(_content) && '' != _content) {
            _content = '<iframe id="' + _frame + '" src="' + _content + '" style="width:100%;height:100%;" frameborder="0" scrolling="no"></iframe>';
        }

        $('#resTabs').tabs('add', {
            id: _id,
            title: _title,
            selected: false,
            fit: true,
            content: _content,
            href: _href
        });
    };

    function addTabs(dataTabs) {
        if (!dataTabs || 0 === dataTabs.length) {
            return;
        }

        for (var idx = 0, max = dataTabs.length; idx < max; idx++) {
            var dataTab = dataTabs[idx];

            addTab(dataTab.Name, dataTab.Title, 0 === idx, dataTab.Frame, dataTab.Content, dataTab.Href)
        };
    }

    function GetDataTabs() {

        var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetOPResource', 'Window', invoker.TAG);
        ajaxGETSync(data, function (ret) {
            try {
                if ('' !== ret) {
                    ret = $.parseJSON(ret.replace(/\'/g, "\"")),
                    addTabs(ret);
                    setTabs();
                }
            } catch (ex) {
                //debugger;
                alert(ex.message || ex);
            }
        }, function (err) {
            alert('GetOPResource error:' + err);
        });

    }

    GetDataTabs();
}

$(function () {
    //debugger;
    $('#resTabs').tabs({
        plain: true,
        narrow: false,
        pill: true,
        justified: true,
        onSelect: function (title, index) {}
    });

    getTabs();

    invoker.emrEditor.sectionResFunc = setTabs;
    window.onunload = function () {
        invoker.emrEditor.sectionResFunc = null;
    }
});
