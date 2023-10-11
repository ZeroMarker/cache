$(function(){
    InitCatList();
    InitCatItemList();
    InitHospital();
    InitSearchLoc();
    InitAuthLocDialog();
});
function InitCatList()
{
    $('#tabCatList').datagrid({
        idField:'ID',
        columns:[[ 
            {field:'ID',hidden:true},   
            {field:'Code',title:'����',width:80,editor:{type:'text'}},    
            {field:'Name',title:'����',width:120,editor:{type:'text'}},    
            {field:'Active',title:'����',width:40,align:'center',
                editor:{type:'checkbox',options:{on:'Y',off:''}},
                styler: function(value,row,index){
                    return value=='Y'?'color:#21ba45;':'color:#f16e57;';
                },
                formatter:function(value,record){
                    return value=='Y'?'��':'��';
                }
            },
            {field:'AuthLoc',hidden:true}
        ]],
        toolbar:[{
            text:'����',
            iconCls: 'icon-add',
            handler: function(){
                $('#tabCatList').datagrid('appendRow',{Active:'Y'});
                var rows= $('#tabCatList').datagrid('getRows');
                $('#tabCatList').datagrid('beginEdit',rows.length-1);
            }
        },'-',{
            text:'ɾ��',
            iconCls: 'icon-remove',
            handler: function(){
                var Selected= $('#tabCatList').datagrid('getSelected');
                if(!Selected){
                    $.messager.popover({msg:"��ѡ����Ҫɾ��������",type:'alert'});
                    return;
                }
                if(!Selected.ID){
                    var index=$('#tabCatList').datagrid('getRowIndex',Selected);
                    $('#tabCatList').datagrid('deleteRow',index);
                    return;
                }
                $.messager.confirm('��ʾ','ȷ��ɾ����ר�����ģ�壿(��ģ�����ĿҲ�ᱻɾ��)',function(r){
                    if(r){
                        var ret=$.cm({
                            ClassName:'DHCDoc.Diagnos.SpecLocTemp',
                            MethodName:'DeleteCat',
                            ID:Selected.ID,
                            dataType:'text'
                        },false);
                        if(ret=='0'){
                            $.messager.popover({msg:"ɾ���ɹ�",type:'success'});
                            $('#tabCatList,#tabItemList').datagrid('reload');
                        }else{
                            $.messager.alert('��ʾ','ɾ��ʧ��:'+ret);
                        }
                    }
                });
            }
        },'-',{
            text:'����',
            iconCls: 'icon-save',
            handler: function(){
                SaveGridData('tabCatList','User.DHCSpecLocDiagCat');
            }
        },'-',{
            text:'��Ȩ����',
            iconCls: 'icon-attachment',
            handler: function(){
                $('#AuthLocDialog').dialog('open');
            }
        }],
        onSelect:function(){
            $('#tabItemList').datagrid('reload');
        },
        onBeforeLoad:function(param){
	        $(this).datagrid('unselectAll');
            param.ClassName='DHCDoc.Diagnos.SpecLocTemp';
            param.QueryName='QueryCat';
        },
        onDblClickRow:function(index, row){
            $('#tabCatList').datagrid('beginEdit',index);
        }
    });
}
function InitCatItemList()
{
    var EditorArr=new Array();
    for(editorName in $.fn.datagrid.defaults.editors){
        EditorArr.push({id:editorName,text:editorName});
    }
    EditorArr.push({id:'keywords',text:'keywords'},{id:'iframe',text:'iframe'});
    $('#tabItemList').datagrid({
        fitColumns:false,
        idField:'ID',
        toolbar:[{
            text:'����',
            iconCls: 'icon-add',
            handler: function(){
                var Selected= $('#tabCatList').datagrid('getSelected');
                if(!Selected){
                    $.messager.popover({msg:"��ѡ��ģ��",type:'alert'});
                    return;
                }
                $('#tabItemList').datagrid('appendRow',{CatDR:Selected.ID,Active:'Y'});
                var rows= $('#tabItemList').datagrid('getRows');
                $('#tabItemList').datagrid('beginEdit',rows.length-1);
            }
        },'-',{
            text:'ɾ��',
            iconCls: 'icon-remove',
            handler: function(){
                var Selected= $('#tabItemList').datagrid('getSelected');
                if(!Selected){
                    $.messager.popover({msg:"��ѡ����Ҫɾ��������",type:'alert'});
                    return;
                }
                if(!Selected.ID){
                    var index=$('#tabItemList').datagrid('getRowIndex',Selected);
                    $('#tabItemList').datagrid('deleteRow',index);
                    return;
                }
                $.messager.confirm('��ʾ','ȷ��ɾ��ѡ������?',function(r){
                    if(r){
                        var ret=$.cm({
                            ClassName:'DHCDoc.Diagnos.SpecLocTemp',
                            MethodName:'DeleteData',
                            ClsName:'User.DHCSpecLocDiagItem',
                            ID:Selected.ID,
                            dataType:'text'
                        },false);
                        if(ret=='0'){
                            $.messager.popover({msg:"ɾ���ɹ�",type:'success'});
                            $('#tabItemList').datagrid('reload');
                        }else{
                            $.messager.alert('��ʾ','ɾ��ʧ��:'+ret);
                        }
                    }
                });
            }
        },'-',{
            text:'����',
            iconCls: 'icon-save',
            handler: function(){
                var Selected= $('#tabCatList').datagrid('getSelected');
                if(!Selected){
                    $.messager.popover({msg:"��ѡ��ģ��",type:'alert'});
                    return;
                }
                SaveGridData('tabItemList','User.DHCSpecLocDiagItem');
            }
        },'-',{
            text:'����',
            iconCls: 'icon-arrow-top',
            handler: function(){
                MoveItemRow('up');
            }
        },'-',{
            text:'����',
            iconCls: 'icon-arrow-bottom',
            handler: function(){
                MoveItemRow('down');
            }
        }],
        columns:[[ 
            {field:'ID',hidden:true}, 
            {field:'CatDR',hidden:true},
            {field:'Code',title:'����',width:100,editor:{type:'text'}},    
            {field:'Name',title:'����',width:120,editor:{type:'text'}},    
            {field:'Active',title:'����',width:50,align:'center',
                editor:{type:'checkbox',options:{on:'Y',off:''}},
                styler: function(value,row,index){
                    return value=='Y'?'color:#21ba45;':'color:#f16e57;';
                },
                formatter:function(value,record){
                    return value=='Y'?'��':'��';
                }
            },
            {field:'Type',title:'�ؼ�����',width:100,align:'center',
                editor:{
                    type:'combobox',
                    options:{
                        url:'',
                        valueField:'id',
                        textField:'text',
                        data:EditorArr
                    }
                }
            },
            {field:'Options',title:'�ؼ�����',width:600,align:'left',editor:{type:'text'}},
            {field:'Style',title:'�ؼ���ʽ',width:400,align:'left',editor:{type:'text'}}
        ]],
        onBeforeLoad:function(param){
	        $(this).datagrid('unselectAll').datagrid('loadData',[]);
            var selected=$('#tabCatList').datagrid('getSelected');
            if(!selected) return false;
            param.ClassName='DHCDoc.Diagnos.SpecLocTemp';
            param.QueryName='QueryCatItem';
            param.CatID=selected?selected.ID:'';
        },
        onDblClickRow:function(index, row){
            $('#tabItemList').datagrid('beginEdit',index);
        }
    });
}
function SaveGridData(id,tableName)
{
    var SaveRows=$('#'+id).datagrid('getEditRows');
    if(!SaveRows||!SaveRows.length){
        $.messager.popover({msg:"û����Ҫ���������",type:'alert'});
        return;
    }
    for(var i=0;i<SaveRows.length;i++){
        var row=SaveRows[i];
        if(!row.Code||!row.Name){
            $.messager.popover({msg:"���������Ʋ���Ϊ��",type:'alert'});
            return;
        }
        if((typeof(row.Type)!='undefined')&&(row.Type=='')){
            $.messager.popover({msg:"�ؼ����Ͳ���Ϊ��",type:'alert'});
            return;
        }
    }
    var ret=tkMakeServerCall('DHCDoc.Diagnos.SpecLocTemp','SaveData',tableName,JSON.stringify(SaveRows));
    if(ret=='0'){
        $.messager.popover({msg:"����ɹ�",type:'success'});
        $('#'+id).datagrid('reload');
    }else{
        $.messager.alert('��ʾ','����ʧ��:'+ret);
    }
}
function MoveItemRow(type)
{
    var Selected= $('#tabItemList').datagrid('getSelected');
    if(!Selected){
        $.messager.popover({msg:"��ѡ����Ҫ�ƶ�����Ŀ",type:'alert'});
        return;
    }
    var index=$('#tabItemList').datagrid('getRowIndex',Selected);
    var rows=$('#tabItemList').datagrid('getRows');
    var changeIndex=-1;
    type=='up'?(changeIndex=index-1):(changeIndex=index+1);
    if((changeIndex<0)||(changeIndex>(rows.length-1))){
        return;
    }
    var row=$.extend({},rows[index]),changeRow=$.extend({},rows[changeIndex]);
    $('#tabItemList').datagrid('updateRow',{index:index,row:changeRow});
    $('#tabItemList').datagrid('updateRow',{index:changeIndex,row:row});
    $('#tabItemList').datagrid('selectRow',changeIndex);
    var SaveRows=new Array();
    for(var i=0;i<rows.length;i++){
        SaveRows.push({ID:rows[i].ID,Sequence:i+1});
    }
    var ret=tkMakeServerCall('DHCDoc.Diagnos.SpecLocTemp','SaveData','User.DHCSpecLocDiagItem',JSON.stringify(SaveRows));
    if(ret=='0'){
    }else{
        $.messager.alert('��ʾ','˳�����ʧ��:'+ret);
        $('#tabItemList').datagrid('reload');
    }
}
function InitAuthLocDialog()
{
    $('#AuthLocDialog').dialog({
        iconCls:'icon-house',
        modal:true,
        minimizable:false,
        maximizable:false,
        collapsible:false,
        closed:true,
        width: 360,    
        height: 550,  
        toolbar:'#tbHosp',  
        buttons:[{
            text:'������Ȩ',
            handler:function(){
                var Selected=$('#tabCatList').datagrid('getSelected');
                var options=$("#LocList").find('option:selected,li[selected]');
                var locIDArr=new Array();
                for(var i=0;i<options.size();i++){
                    locIDArr.push(options.eq(i).val());
                }
                var ret=$.cm({
                    ClassName:'DHCDoc.Diagnos.SpecLocTemp',
                    MethodName:'SaveLocAuth',
                    CatID:Selected.ID, HospID:$('#_HospList').getValue(), LocIDStr:locIDArr.join(','),
                    dataType:'text'
                },false);
                if(ret=='0'){
                    $.messager.popover({msg:"��Ȩ�ɹ�",type:'success'});
                }else{
                    $.messager.alert('��ʾ','��Ȩʧ��:'+ret);
                }
            }
        }],
        onBeforeOpen:function(){
            var Selected= $('#tabCatList').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"��ѡ����Ҫ��Ȩ������",type:'alert'});
                return false;
            }
            $('#AuthLocDialog').dialog('setTitle',Selected.Name+' ������Ȩ');
            return true;
        },
        onOpen:function(){
            var HospID=$('#_HospList').getValue();
            if(session['LOGON.HOSPID']==HospID){
                LoadAuthLocList();
            }else{
                $('#_HospList').setValue(session['LOGON.HOSPID']);
            }
        }
    });
}
function LoadAuthLocList()
{
    $('#LocList').empty();
    $('#searchLoc').searchbox('setValue','');
    var Selected= $('#tabCatList').datagrid('getSelected');
    if(!Selected) return;
    $.cm({
        ClassName:'DHCDoc.Diagnos.SpecLocTemp',
        QueryName:'QueryAuthLoc',
        CatID:Selected.ID,
        HospID:$('#_HospList').getValue(),
        rows:99999
    },function(data){
        var rows=data.rows;
        for(var i=0;i<rows.length;i++){
            var row=rows[i];
            $("<option></option>").val(row.LocID).text(row.LocDesc).attr('alias',row.LocAlias).attr('selected',row.selected==1).appendTo('#LocList');
        }
    });
}
function InitHospital()
{
    $('#_HospList').combobox({
        onSelect:LoadAuthLocList,
        onBeforeLoad:function(param){
            $.extend(param,{ClassName:'DHCDoc.Diagnos.SpecLocTemp',QueryName:'QueryHospital'});
        }
    });
}
function InitSearchLoc()
{
    $('#searchLoc').searchbox({
        prompt:'������������ƻ��ƴ��������...',
        searcher:function(value,name){
            value=value.toUpperCase();
            $("#LocList>option,#LocList>li").each(function(){
                var alias=$(this).attr('alias').toUpperCase();
                var text=$(this).text().toUpperCase();
                var val=$(this).val();
                var tagName=$(this).prop("tagName");
                var selected=(tagName=='OPTION'?$(this).is(':selected'):$(this).attr('selected'))||false;
                if((alias.indexOf(value)==-1)&&(text.indexOf(value)==-1)){
                    $('<li></li>').val(val).text(text).attr('alias',alias).attr('selected',selected).insertAfter(this);
                }else{
                    $("<option></option>").val(val).text(text).attr('alias',alias).attr('selected',selected).insertBefore(this);
                }
                $(this).remove();
            });
        }
    });
}