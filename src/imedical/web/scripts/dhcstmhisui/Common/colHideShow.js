	/**
	 * DataGrid��ͷ�һ��в˵�   ����/��ʾ
	 * XuChao
	 * 20180507
	 */
var createGridHeaderContextMenu = function(e, field) {  
    e.preventDefault();  
    var grid = $(this);/* grid���� */  
    var headerContextMenu = this.headerContextMenu;/* grid�ϵ���ͷ�˵����� */  
    var okCls = 'tree-checkbox1';// ѡ��  
    var emptyCls = 'tree-checkbox0';// ȡ��  
    if (!headerContextMenu) {  
        var tmenu = $('<div class="GridHeaderContexMenu" style="width:100px;"></div>').appendTo('body');  
        var fields = grid.datagrid('getColumnFields');  
        for (var i = 0; i < fields.length; i++) {  
            var fildOption = grid.datagrid('getColumnOption', fields[i]);  
            //checkbox ����ʾ
            if(fildOption.checkbox===true){
            	continue;
            }
            if (!fildOption.hidden) {  
                $('<div iconCls="' + okCls + '" field="' + fields[i] + '"/>')  
                        .html(fildOption.title).appendTo(tmenu);  
            } else {  
                $('<div iconCls="' + emptyCls + '" field="' + fields[i] + '"/>')  
                        .html(fildOption.title).appendTo(tmenu);  
            }  
        }  
        headerContextMenu = this.headerContextMenu = tmenu.menu({  
            onClick : function(item) {  
                var field = $(item.target).attr('field');  
                if (item.iconCls == okCls) {  
                    grid.datagrid('hideColumn', field);  
                    $(this).menu('setIcon', {  
                        target : item.target,  
                        iconCls : emptyCls  
                    });  
                } else {  
                    grid.datagrid('showColumn', field);  
                    $(this).menu('setIcon', {  
                        target : item.target,  
                        iconCls : okCls  
                    });  
                }  
            }  
        });  
    }  
    headerContextMenu.menu('show', {  
        left : e.pageX,  
        top : e.pageY  
    });  
};  
$.fn.datagrid.defaults.onHeaderContextMenu = createGridHeaderContextMenu;  
$.fn.treegrid.defaults.onHeaderContextMenu = createGridHeaderContextMenu;  