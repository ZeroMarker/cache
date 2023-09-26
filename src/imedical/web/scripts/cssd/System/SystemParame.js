// 名称:参数设置管理

var init = function(){
    
    var ReSetAppParam = {
        text : '初始化参数',
        iconCls : 'icon-init',
        handler : function(){
            if(!confirm('第一次提示: 您正在重置参数, 这会删除之前的所有参数数据, 是否继续?')){
                return;
            }
            if(!confirm('第二次提示: 您正在重置参数, 这会删除之前的所有参数数据, 是否继续?')){
                return;
            }
            if(!confirm('最后一次提示: 您正在重置参数, 这会删除之前的所有参数数据, 是否继续?')){
                return;
            }
            
            var result = tkMakeServerCall('web.CSSDHUI.Init.InitParamete', 'ReSetParame');
            if(result<0){
                $UI.msg('error', '当前暂无数据，无法进行初始化，请先同步数据！');
            }else{
                $UI.msg('success', '重置成功!');
                $UI.clear(AppGrid);
                $UI.clear(AppParamGrid);
                AppGrid.reload();
            }
        }
    };
    var AppSynBT = {
        text: '同步应用',
        iconCls: 'icon-reload',
        handler: function(){
            var synRet = tkMakeServerCall('web.CSSDHUI.Init.InitParamete','InitParameter');
            var synRetArr = synRet.split('^');
            $UI.msg('success', '同步数据成功！');
            $UI.clear(AppGrid);
            $UI.clear(AppParamGrid);
            AppGrid.reload();
        }
    };
    
    var AppGrid = $UI.datagrid('#AppGrid', {
        lazy: false,
        queryParams: {
            ClassName: 'web.CSSDHUI.System.BaseCodeType',
            QueryName: 'SelectAll',
            type:"C"
        },
        remoteSort: false,
        pagination: false,
        toolbar: [ReSetAppParam, AppSynBT],
        showAddDelItems: false,
        fitColumns: true,
        columns: [[
            {
                title: 'RowId',
                field: 'RowId',
                width: 80,
                hidden: true
            },{
                title: '代码',
                field: 'Code',
                width: 200
            },{
                title: '名称',
                field: 'Description',
                width: 200
            }
        ]],
        onSelect: function(index, row){
            var Parref = row['RowId'];
            $UI.clear(AppParamGrid);
            AppParamGrid.load({
                ClassName: 'web.CSSDHUI.System.SystemParame',
                MethodName: 'SelectAll',
                Parref: Parref
            });
        }
    });

    
    var AppParamSaveBT = {
        text: '保存',
        iconCls: 'icon-save',
        handler: function(){
            var AppRow = AppGrid.getSelected();
            if(isEmpty(AppRow)){
                $UI.msg('alert', '请选择相应的应用程序!');
                return;
            }
            var Parref = AppRow['RowId'];
            var Detail = AppParamGrid.getChangesData('Code');
            if(isEmpty(Detail)){
                $UI.msg('alert', '没有需要保存的内容!');
                return;
            }
            $.cm({
                ClassName: 'web.CSSDHUI.System.SystemParame',
                MethodName: 'Save',
                Parref: Parref,
                Detail: JSON.stringify(Detail)
            },function(jsonData){
                if(jsonData.success === 0){
                    $UI.msg('success', jsonData.msg);
                    AppParamGrid.reload();
                }else{
                    $UI.msg('error', jsonData.msg);
                }
            });
        }
    }
    
    var AppParamGrid = $UI.datagrid('#AppParamGrid', {
        queryParams: {
            ClassName: 'web.CSSDHUI.System.SystemParame',
            MethodName: 'SelectAll',
            rows: 999
        },
        remoteSort: false,
        //deleteRowParams: {
        //    ClassName: 'web.CSSDHUI.System.SystemParame',
        //    MethodName: 'Delete'
        //},
        pagination: false,
        //toolbar: [AppParamSaveBT],
        showAddSaveDelItems: true,
        beforeAddFn: function(){
            var AppRow = AppGrid.getSelected();
            if(isEmpty(AppRow)){
                $UI.msg('alert', '请选择相应的参数!');
                return false;
            }
        },
		beforeDelFn:function(){
			var parameRow = $('#AppParamGrid').datagrid('getSelected');
			if(!isEmpty(parameRow)){
				var parameRowid = parameRow.RowId;
				if (!isEmpty(parameRowid)) {
					$UI.msg('alert','参数已维护，不能删除!');
					return false;
				}
			}else{
				$UI.msg('alert','请选择要删除的单据!');
				return false;
			}
		},
        saveDataFn: function(){
            var AppRow = AppGrid.getSelected();
            if(isEmpty(AppRow)){
                $UI.msg('alert', '请选择相应的应用程序!');
                return;
            }
            var Parref = AppRow['RowId'];
            var Detail = AppParamGrid.getChangesData();
            if(isEmpty(Detail)){
                //$UI.msg('alert', '没有需要保存的内容!');
                return;
            }
            $.cm({
                ClassName: 'web.CSSDHUI.System.SystemParame',
                MethodName: 'Save',
                Parref: Parref,
                Detail: JSON.stringify(Detail)
            },function(jsonData){
                if(jsonData.success === 0){
                    $UI.msg('success', jsonData.msg);
                    AppParamGrid.reload();
                }else{
                    $UI.msg('error', jsonData.msg);
                }
            });
        },
        fitColumns: true,
        columns: [[
            {
                title: 'RowId',
                field: 'RowId',
                width: 80,
                hidden: true
            },{
                title: '代码',
                field: 'Code',
                width: 150,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },{
                title: '名称',
                field: 'Description',
                width: 200,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },{
                title: '参数值',
                align:'left',
                field: 'ParaValue',
                width: 200,
                editor: 'validatebox'
            }
        ]],
        onClickCell: function(index, field ,value){
            AppParamGrid.commonClickCell(index, field);
        },
        onBeforeCellEdit: function(index, field){
            var RowData = $(this).datagrid('getRows')[index];
            if(field == 'Code' && !isEmpty(RowData['RowId'])){
                return false;
            }
        }
    });
    
    

}
$(init);