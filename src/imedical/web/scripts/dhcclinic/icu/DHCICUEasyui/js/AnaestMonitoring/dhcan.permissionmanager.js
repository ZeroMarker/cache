var permissions = {
    /**
     * 数据编辑权限
     */
    editable: true,
    /**
     * 以下依照按钮的分组来设置权限
     */
    toolgroup: {
        /**
         * 流程操作权限
         */
        Flow: true,
        /**
         * 翻页权限
         */
        Page: true,
        /**
         * 文档操作权限
         */
        Doc: true
    }
}

var permissionManager = {
    setCurrentPermissions: function() {
        var operSchedule = record.context.schedule;
        if (this.isUserPermitted(operSchedule) && !this.readonly()) {
            $.extend(permissions, {
                editable: true,
                toolgroup: {
                    Flow: true,
                    Page: true,
                    Doc: true
                }
            });
        } else {
            $.extend(permissions, {
                editable: false,
                toolgroup: {
                    Flow: false,
                    Page: true,
                    Doc: false
                }
            });
        }
        if (session.ModuleCode == 'AnaestRecord') this.setStatusPermission(operSchedule);
        else if (session.ModuleCode == 'PACURecord') this.setStatusPermissionPACU(operSchedule);
        return permissions;
    },
    isUserPermitted: function(operSchedule) {
        return session.Editable;
    },
    readonly: function() {
        var readonly = dhccl.getQueryString('readonly');
        if (readonly && readonly == 'true') return true;
        return false;
    },
    setStatusPermission: function(operSchedule) {
        switch (operSchedule.StatusCode) {
            case 'Decline':
            case 'Cancel':
            case 'Application':
            case 'Audit':
                permissions.editable = permissions.editable && false;
                permissions.toolgroup.Flow = permissions.toolgroup.Flow && false;
                permissions.toolgroup.Page = permissions.toolgroup.Page && false;
                permissions.toolgroup.Doc = permissions.toolgroup.Doc && false;
                break;
                break;
            case 'Arrange':
            case 'AreaIn':
            case 'Revoke':
                permissions.editable = permissions.editable && false;
                permissions.toolgroup.Flow = permissions.toolgroup.Flow && true;
                permissions.toolgroup.Page = permissions.toolgroup.Page && true;
                permissions.toolgroup.Doc = permissions.toolgroup.Doc && true;
                break;
            case 'RoomIn':
            case 'RoomOut':
            case 'PACUIn':
            case 'PACUOut':
            case 'AreaOut':
                permissions.editable = permissions.editable && true;
                permissions.toolgroup.Flow = permissions.toolgroup.Flow && true;
                permissions.toolgroup.Page = permissions.toolgroup.Page && true;
                permissions.toolgroup.Doc = permissions.toolgroup.Doc && true;
                break;
            case 'Finish':
                permissions.editable = permissions.editable && true;
                permissions.toolgroup.Flow = permissions.toolgroup.Flow && true;
                permissions.toolgroup.Page = permissions.toolgroup.Page && true;
                permissions.toolgroup.Doc = permissions.toolgroup.Doc && true;
                break;
        }
    },
    setStatusPermissionPACU: function(operSchedule) {
        switch (operSchedule.StatusCode) {
            case 'Decline':
            case 'Cancel':
            case 'Application':
            case 'Audit':
            case 'Arrange':
            case 'AreaIn':
            case 'Revoke':
            case 'RoomIn':
                permissions.editable = permissions.editable && false;
                permissions.toolgroup.Flow = permissions.toolgroup.Flow && false;
                permissions.toolgroup.Page = permissions.toolgroup.Page && false;
                permissions.toolgroup.Doc = permissions.toolgroup.Doc && false;
                break;
            case 'RoomOut':
                permissions.editable = permissions.editable && false;
                permissions.toolgroup.Flow = permissions.toolgroup.Flow && true;
                permissions.toolgroup.Page = permissions.toolgroup.Page && true;
                permissions.toolgroup.Doc = permissions.toolgroup.Doc && true;
                break;
            case 'PACUIn':
                permissions.editable = permissions.editable && true;
                permissions.toolgroup.Flow = permissions.toolgroup.Flow && true;
                permissions.toolgroup.Page = permissions.toolgroup.Page && true;
                permissions.toolgroup.Doc = permissions.toolgroup.Doc && true;
                break;
            case 'PACUOut':
            case 'AreaOut':
            case 'Finish':
                permissions.editable = permissions.editable && true;
                permissions.toolgroup.Flow = permissions.toolgroup.Flow && true;
                permissions.toolgroup.Page = permissions.toolgroup.Page && true;
                permissions.toolgroup.Doc = permissions.toolgroup.Doc && true;
                break;
        }
    }
}