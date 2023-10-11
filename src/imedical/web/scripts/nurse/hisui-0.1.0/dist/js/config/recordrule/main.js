/*
 * @Descripttion: ������ģ�幦������
 * @Author: yaojining
 * @Date: 2021-12-29 17:09:38
 */
var GLOBAL = {
    HospEnvironment: true,
    HospitalID: session['LOGON.HOSPID'],
    ClassName: 'NurMp.Service.Template.Rule',
    ConfigTableName: 'Nur_IP_BatchEdit',
    Template: null
};
var init = function () {
    initHosp(GLOBAL.ConfigTableName, reloadTempTree);
    initTemplateTree();
    initTabs();
    listenEvent();
};

$(init);

/**
 * @description: ģ����
 */
function initTemplateTree() {
    $('#ulTemplateTree').tree({
        loader: function (param, success, error) {
            $cm({
                ClassName: GLOBAL.ClassName,
                MethodName: "GetPubTemplate",
                HospitalID: GLOBAL.HospitalID,
                FilterDesc: $('#sbTemplate').searchbox('getValue'),
                RegTableName: GLOBAL.ConfigTableName
            }, function (data) {
                var addIDAndText = function (node) {
                    if (!!node.locDesc) {
                        node.text = node.text + "&nbsp;&nbsp;<label style='font-size:12px;font-style:italic;color:red;'>" + node.locDesc + "</label>";
                    }
                }
                data.forEach(addIDAndText);
                success(data);
            });
        },
        onSelect: function (node) {
            GLOBAL.Template = node;
        }
    });
}
function initTabs() {
    $('#tabContent').tabs({
        onSelect: function (title, index) {
            updateTab(index);
        }
    });
    updateTab(0);
    $('#tabContent').tabs('select', 0);
}
/**
 * @description: ˢ��ģ����
 */
function reloadTempTree() {
    $('#ulTemplateTree').tree('reload');
}
/**
 * @description: ˢ�µ�ǰҳǩҳ
  */
function updateTab(index) {
    var targetTab = $('#tabContent').tabs('getTab', index);
    if (!!targetTab) {
        var currentFrame = targetTab[0].firstElementChild;
        var iframeId = $(currentFrame).attr('id');
        var oriSrc = $(currentFrame).attr('src').split('?')[0];
        var iframeSrc = oriSrc + '?HospitalID=' + GLOBAL.HospitalID;
        if ((!!iframeId) && (!!iframeSrc)) {
            var content = '<iframe id="' + iframeId + '" frameborder="0" scrolling="auto" src="' + iframeSrc + '" style="width:100%;height:100%;"></iframe>';
            $('#tabContent').tabs('update', {
                tab: targetTab,
                options: {
                    content: content
                }
            });
        }
    }
}
/**
 * @description: �¼�
 */
function listenEvent() {
    $('#sbTemplate').searchbox("textbox").keydown(function (e) {
        if (e.keyCode == 13) {
            reloadTempTree();
        }
    });
    $('.searchbox-button').bind('click', function() {
        reloadTempTree();
    });
}