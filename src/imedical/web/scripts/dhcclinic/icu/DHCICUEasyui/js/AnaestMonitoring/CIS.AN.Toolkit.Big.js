/**
 * 工具栏
 * @author yongyang 20180511
 */

(function(global, factory) {
    if (!global.Toolkit) factory(global.Toolkit = {});
}(this, function(exports) {

    exports.init = function(dom, opt) {
        var view = new Toolkit(dom, opt);
        exports.instance = view;
        return view;
    }

    function Toolkit(dom, opt) {
        this.dom = $(dom);
        this.options = opt;
        this.actions = opt.data || [];
        this.init();
    }

    Toolkit.prototype = {
        init: function() {
            this.groups = groupingActions(this.actions);
            groupView.render(this.dom, this.groups);
        },
        loadData: function(activeActions) {
            this.activeActions = activeActions;
            this.adjust();
        },
        loadPermission: function(permissionManager) {
            this.permissionManager = permissionManager;
        },
        adjust: function() {
            this.disableAll();

            var activeDic = {};
            var length = this.activeActions.length;
            for (var i = 0; i < length; i++) {
                var actvieAction = this.activeActions[i];
                activeDic[actvieAction.OperAction] = true;
            }

            var length = this.groups.length;
            for (var i = 0; i < length; i++) {
                var group = this.groups[i];
                var permitted = !this.permissionManager || this.permissionManager.toolgroup[group.name];
                var actionLength = group.items.length;
                for (var j = 0; j < actionLength; j++) {
                    var action = group.items[j];
                    if (permitted && activeDic[action.RowId]) {
                        action.target.linkbutton('enable');
                        action.target.find('span.l-btn-icon').removeClass('icon-disabled');
                        action.target.show();
                    } else {
                        action.target.hide();
                    }
                }
            }
        },
        disableAll: function() {
            var foundActions = this.dom.find('a.toolkit-action')
            if (foundActions.length > 0) {
                foundActions.linkbutton('disable');
                foundActions.find('span.l-btn-icon').addClass('icon-disabled');
            }
        },
        enable: function(id) {
            var foundAction = this.dom.find('#' + id);
            if (foundAction.length > 0) {
                foundAction.linkbutton('enable');
                foundAction.find('span.l-btn-icon').removeClass('icon-disabled');
            }
        }
    }

    var groupView = {
        render: function(container, groups) {
            $.each(groups, function(index, group) {
                var kit = $('<div class="toolkit-group toolkit-group-big"></div>').appendTo(container);
                actionView.render(kit, group.items);
            });
        }
    };

    var actionView = {
        idPrefix: 'toolkit_action_i_',
        render: function(container, actions) {
            var idPrefix = this.idPrefix;
            $.each(actions, function(index, action) {
                var btn = $('<a href="#" class="toolkit-action toolkit-action-big"></a>')
                    .text(action.Description)
                    .attr('title', action.Description)
                    .attr('id', idPrefix + action.RowId)
                    .linkbutton({
                        iconCls: action.Icon,
                        plain: true,
                        disabled: false,
                        onClick: window[action.ExecFunc] //从全局变量中获取对应方法
                    })
                    .appendTo(container);
                btn.data('data', action);
                action.target = btn;
            });
        }
    };

    function groupingActions(actions) {
        var result = [];
        var groups = [];
        $.each(actions, function(index, action) {
            var groupIndex = groups.indexOf(action.ElementID);
            var currentGroup = null;
            if (groupIndex >= 0) {
                currentGroup = result[groupIndex];
            } else {
                groups.push(action.ElementID);
                currentGroup = {
                    name: action.ElementID,
                    items: []
                }
                result.push(currentGroup);
            }
            currentGroup.items.push(action);
        });
        return result;
    }
}))