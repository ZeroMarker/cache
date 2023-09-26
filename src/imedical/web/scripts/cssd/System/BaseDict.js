// ����:�������ù���

var init = function(){
    
    var ReSetAppParam = {
        text : '��ʼ������',
        iconCls : 'icon-init',
        handler : function(){
            if(!confirm('��һ����ʾ: ���������ò���, ���ɾ��֮ǰ�����в�������, �Ƿ����?')){
                return;
            }
            if(!confirm('�ڶ�����ʾ: ���������ò���, ���ɾ��֮ǰ�����в�������, �Ƿ����?')){
                return;
            }
            if(!confirm('���һ����ʾ: ���������ò���, ���ɾ��֮ǰ�����в�������, �Ƿ����?')){
                return;
            }
            
            
            var result = tkMakeServerCall('web.CSSDHUI.Init.InitBaseData', 'ReSetParame');
            if(result<0){
                $UI.msg('error', '��ǰ�������ݣ��޷����г�ʼ��������ͬ�����ݣ�');
            }else{
                $UI.msg('success', '���óɹ�!');
                $UI.clear(AppGrid);
                $UI.clear(AppParamGrid);
                AppGrid.reload();
            }
        }
    };
    var AppSynBT = {
        text: 'ͬ��Ӧ��',
        iconCls: 'icon-reload',
        handler: function(){
            var synRet = tkMakeServerCall('web.CSSDHUI.Init.InitBaseData','InitParameter');
            var synRetArr = synRet.split('^');
            $UI.msg('success', 'ͬ�����ݳɹ���');
            $UI.clear(AppParamGrid);
            AppGrid.reload();
        }
    };
    
    var AppGrid = $UI.datagrid('#AppGrid', {
        lazy: false,
        queryParams: {
            ClassName: 'web.CSSDHUI.System.BaseCodeType',
            QueryName: 'SelectAll',
            type:"Y"
        },
        remoteSort: false,
        pagination: false,
        toolbar: [ReSetAppParam, AppSynBT],
        fitColumns: true,
        columns: [[
            {
                title: 'RowId',
                field: 'RowId',
                width: 80,
                hidden: true
            },{
                title: '����',
                align:'left',
                field: 'Code',
                width: 200
            },{
                title: '����',
                field: 'Description',
                width: 200
            }
        ]],
        onSelect: function(index, row){
            var Parref = row['Code'];
            $UI.clear(AppParamGrid);
            AppParamGrid.load({
                ClassName: 'web.CSSDHUI.System.BaseCode',
                MethodName: 'SelectAll',
                Parref: Parref
            });
        }
    });

    
    
    
    var AppParamGrid = $UI.datagrid('#AppParamGrid', {
        queryParams: {
            ClassName: 'web.CSSDHUI.System.BaseCode',
            MethodName: 'SelectAll',
            rows: 999
        },
        remoteSort: false,
        deleteRowParams: {
            ClassName: 'web.CSSDHUI.System.BaseCode',
            MethodName: 'Delete'
        },
        pagination: false,
        //toolbar: [AppParamSaveBT],
        saveDataFn:function(){
            var AppRow = AppGrid.getSelected();
            if(isEmpty(AppRow)){
                $UI.msg('alert', '��ѡ����Ӧ��Ӧ�ó���!');
                return;
            }
            var Parref = AppRow['RowId'];
            var Detail = AppParamGrid.getChangesData('Code');
            if(isEmpty(Detail)){
                $UI.msg('alert', 'û����Ҫ���������!');
                return;
            }
            $.cm({
                ClassName: 'web.CSSDHUI.System.BaseCode',
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
        beforeAddFn: function(){
            var AppRow = AppGrid.getSelected();
            if(isEmpty(AppRow)){
                $UI.msg('alert', '��ѡ����Ӧ�Ĳ���!');
                return false;
            }
        },
        fitColumns: true,
        columns: [[
            {
                title: 'RowId',
                field: 'RowId',
                width: 80,
                hidden: true
            },{
                title:'��������',
                field:'CodeType',
                width:80,
                hidden:true
            },{
                title: '����',
                align:'left',
                field: 'Code',
                width: 150,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },{
                title: '����',
                field: 'Description',
                width: 200,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },{
                title: '����',
                align:'left',
                field: 'BegLabel',
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