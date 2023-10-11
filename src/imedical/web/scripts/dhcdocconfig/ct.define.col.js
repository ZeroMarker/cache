$(function(){
    if(!ServerObj.DefineID) return;
    InitColCfgList();
});
function InitColCfgList()
{
    var EditorArr=new Array();
    for(editorName in $.fn.datagrid.defaults.editors){
        EditorArr.push({id:editorName,text:editorName});
    }
    $('#tabColCfgList').datagrid({
        fitColumns:false,
        idField:'ID',
        toolbar:[{
            text:'增加',
            iconCls: 'icon-add',
            handler: function(){
                $('#tabColCfgList').datagrid('appendRow',{DefineDR:ServerObj.DefineID,Active:'Y'});
                var rows= $('#tabColCfgList').datagrid('getRows');
                $('#tabColCfgList').datagrid('beginEdit',rows.length-1);
            }
        },'-',{
            text:'删除',
            iconCls: 'icon-remove',
            handler: function(){
                var Selected= $('#tabColCfgList').datagrid('getSelected');
                if(!Selected){
                    $.messager.popover({msg:"请选择需要删除的数据",type:'alert'});
                    return;
                }
                if(!Selected.DefineDR){
                    var index=$('#tabColCfgList').datagrid('getRowIndex',Selected);
                    $('#tabColCfgList').datagrid('deleteRow',index);
                }else{
					$.messager.confirm('提示','确定删除选中数据?',function(r){
						if(r){
							var ret=$.cm({
								ClassName:'DHCDoc.Diagnos.SpecLocTemp',
								MethodName:'DeleteData',
								ClsName:'User.DHCDocCTDefineColCfg',
								ID:Selected.ID,
								dataType:'text'
							},false);
							if(ret=='0'){
								$.messager.popover({msg:"删除成功",type:'success'});
								$('#tabColCfgList').datagrid('reload');
							}else{
								$.messager.alert('提示','删除失败:'+ret);
							}
						}
					});
				}
            }
        },'-',{
            text:'保存',
            iconCls: 'icon-save',
            handler: function(){
                SaveGridData('tabColCfgList','User.DHCDocCTDefineColCfg');
            }
        }],
        columns:[[ 
            {field:'ID',hidden:true}, 
            {field:'DefineDR',hidden:true},
            {field:'Code',title:'代码',width:100,editor:{type:'text'}},    
            {field:'Name',title:'名称',width:120,editor:{type:'text'}},    
            {field:'Active',title:'激活',width:50,align:'center',
                editor:{type:'checkbox',options:{on:'Y',off:''}}
            },
            {field:'Sequence',title:'顺序',width:50,align:'center',
                editor:{type:'numberbox',options:{min:1}}
            },
            {field:'Type',title:'控件类型',width:100,align:'center',
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
            {field:'Options',title:'控件属性',width:600,align:'left',editor:{type:'text'}},
            {field:'Style',title:'控件样式',width:400,align:'left',editor:{type:'text'}}
        ]],
        onBeforeLoad:function(param){
            param.ClassName='DHCDoc.DHCDocConfig.CodeTable';
            param.QueryName='QueryColCfg';
            param.DefineID=ServerObj.DefineID; 
        },
        onDblClickRow:function(index, row){
            $(this).datagrid('beginEdit',index);
        }
    });
}
function SaveGridData(id,tableName)
{
    var SaveRows=new Array();
    var CodeArr=new Array();
    var rows= $('#'+id).datagrid('getRows');
    for(var i=0;i<rows.length;i++){
        var Editors=$('#'+id).datagrid('getEditors',i);
	    var Code=(Editors.length?$(Editors[0].target).getValue():rows[i].Code).toUpperCase();
        if(CodeArr.indexOf(Code)>-1){
	    	$.messager.popover({msg:"代码'"+Code+"'重复维护",type:'error'});
            return;
	    }
	    CodeArr.push(Code);
        if(!Editors.length) continue;
        var row=rows[i];
        for(var j=0;j<Editors.length;j++){
            row[Editors[j].field]=$(Editors[j].target).getValue();
            if(Editors[j].type=='checkbox'){
                row[Editors[j].field]=row[Editors[j].field]?"Y":"N";
            }
        }
        for(var key in row){
            if(row[key]==undefined) row[key]="";
        }
        if(!row.Code||!row.Name){
            $.messager.popover({msg:"代码与名称不能为空",type:'alert'});
            return;
        }
        SaveRows.push(row);
    }
    if(!SaveRows||!SaveRows.length){
        $.messager.popover({msg:"没有需要保存的数据",type:'alert'});
        return;
    }
    var ret=tkMakeServerCall('DHCDoc.Diagnos.SpecLocTemp','SaveData',tableName,JSON.stringify(SaveRows));
    if(ret=='0'){
        $.messager.popover({msg:"保存成功",type:'success'});
        $('#'+id).datagrid('reload');
    }else{
        $.messager.alert('提示','保存失败:'+ret);
    }
}