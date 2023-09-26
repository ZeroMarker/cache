var GridColSet=function(gridObj){
    var StrParam=gGroupId+"^"+gLocId+"^"+gUserId+"^"+gHospId
    var GridColSetPer = tkMakeServerCall('web.CSSDHUI.Common.AppCommon','GetCommPropValue','GridColSetPer',StrParam);
    if(GridColSetPer=="N")
    {$UI.msg("error", "��û��Ȩ�޴������ã�"); return;}
    var colsetcm=gridObj.jdata.options.columns;
    var colsetid=gridObj.jqselector;
    var CommonObj={
            AppName:'CSSDPACKAGE',
            CspName:App_MenuCspName,
            GridId:colsetid 
    }   
    var ColSetClear=function(){
        $UI.clearBlock('#ColSetConditions');
        $UI.clear(ColSetGrid);
        var ColSetDafult={
            SaveMod:'SITE'          
            }
        $UI.fillBlock('#ColSetConditions',ColSetDafult)
    }
    $UI.linkbutton('#ColSetSaveBT',{
        onClick:function(){
            var MainObj=$UI.loopBlock('#ColSetConditions')
            var MainObj=$.extend(MainObj,CommonObj)
            var Main=JSON.stringify(MainObj)
            var Detail=ColSetGrid.getRowsData();
            if(Detail===false){return}; //��֤δͨ��  ���ܱ���
            $.cm({
                ClassName: 'web.CSSDHUI.CssdSysGridSet',
                MethodName: 'Save',
                Main: Main,
                Detail: JSON.stringify(Detail)
            },function(jsonData){
                if(jsonData.success==0){
                    $UI.msg('success',jsonData.msg);
                    ColSetFind();
                }else{
                    $UI.msg('error',jsonData.msg);
                }
            });
        }
    });
    $UI.linkbutton('#ColSetInitBT',{
        onClick:function(){ 
        var MainObj=$UI.loopBlock('#ColSetConditions')
        var MainObj=$.extend(MainObj,CommonObj)
        var Main=JSON.stringify(addSessionParams(MainObj));
            function del(){
                $.cm({
                    ClassName: 'web.CSSDHUI.CssdSysGridSet',
                    MethodName: 'Delete',
                    Main: Main
                },function(jsonData){
                    if(jsonData.success==0){
                        $UI.msg('success',jsonData.msg);
                        ColSetFind();
                    }else{
                        $UI.msg('error',jsonData.msg);
                    }
                });                 
            }
            $UI.confirm('ȷ��Ҫɾ����?','','', del)
        }
    }); 
    var Alignbox = {
        type: 'combobox',
        options: {
            data:[{
                RowId: 'left',
                Description: 'left'
            },{
                RowId: 'right',
                Description: 'right'
            },{
                RowId: 'center',
                Description: 'center'
            }],
            valueField: 'RowId',
            textField: 'Description'
        }
    };
    var ColSetGridCm = [[
        {title : 'RowId', field : 'RowId', hidden : true},
        {title : '����', field : 'Header', width : 100},      
        {title : '����', field : 'Name', width : 150, editor : { type : 'text'}},
        {title : '���', field : 'Width', width : 100, align : 'right' , editor : { type : 'text'}},
        {title : '���뷽ʽ', field : 'Align', width : 100, align : 'center' , editor : Alignbox},
        {title : '�س���ת˳��',field:'EnterSort',width : 100, align : 'right', editor : { type : 'text'}},       
        {title : '���ر�־', field : 'Hidden', editor : {type :'checkbox',options:{on:'Y',off:'N'}},width : 100, align : 'center'},
        {title : '��Ҫ��־', field : 'Necessary', editor : {type :'checkbox',options:{on:'Y',off:'N'}},width : 100, align : 'center'},
        {title : '����', field : 'Frozen', editor : {type :'checkbox',options:{on:'Y',off:'N'}},width : 100, align : 'center'}
        ]];
    
    var ColSetGrid = $UI.datagrid('#ColSetGrid', {
        url:'',
        queryParams: {
            ClassName: 'web.CSSDHUI.CssdSysGridSet',
            QueryName: 'GetGridSet'
        },
        columns: ColSetGridCm,
        toolbar:'#btn',
        pagination:false,
        onClickCell: function(index, filed ,value){ 
            ColSetGrid.commonClickCell(index,filed,value);
        },
        onLoadSuccess:function(){
            $(this).datagrid('enableDnd');
        }
    });
    $('#ColSetWin').window({
        width: 1000,
        height: 500,
        modal: true
    });
    $HUI.window('#ColSetWin').open();
    var ColSetFind=function(){
        var Main=JSON.stringify(addSessionParams(CommonObj));
        var Mod = $.m({
            ClassName: 'web.CSSDHUI.CssdSysGridSet',
            MethodName: 'JsGetSaveMod',
            Main:Main
        },false);
        var Model=Mod.split('^')[0];
        $HUI.radio('#'+Model).setValue(true);
        var Detail=JSON.stringify(colsetcm[0].reverse());
        colsetcm[0].reverse();
        $UI.setUrl(ColSetGrid)
        ColSetGrid.load({
            ClassName: 'web.CSSDHUI.CssdSysGridSet',
            QueryName: 'GetGridSet',
            Main:Main,
            Detail:Detail
        });
    }
    ColSetClear();
    ColSetFind();
}