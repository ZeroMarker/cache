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
            text:'����',
            iconCls: 'icon-add',
            handler: function(){
                $('#tabColCfgList').datagrid('appendRow',{DefineDR:ServerObj.DefineID,Active:'Y'});
                var rows= $('#tabColCfgList').datagrid('getRows');
                $('#tabColCfgList').datagrid('beginEdit',rows.length-1);
            }
        },'-',{
            text:'ɾ��',
            iconCls: 'icon-remove',
            handler: function(){
                var Selected= $('#tabColCfgList').datagrid('getSelected');
                if(!Selected){
                    $.messager.popover({msg:"��ѡ����Ҫɾ��������",type:'alert'});
                    return;
                }
                if(!Selected.DefineDR){
                    var index=$('#tabColCfgList').datagrid('getRowIndex',Selected);
                    $('#tabColCfgList').datagrid('deleteRow',index);
                }else{
					$.messager.confirm('��ʾ','ȷ��ɾ��ѡ������?',function(r){
						if(r){
							var ret=$.cm({
								ClassName:'DHCDoc.Diagnos.SpecLocTemp',
								MethodName:'DeleteData',
								ClsName:'User.DHCDocCTDefineColCfg',
								ID:Selected.ID,
								dataType:'text'
							},false);
							if(ret=='0'){
								$.messager.popover({msg:"ɾ���ɹ�",type:'success'});
								$('#tabColCfgList').datagrid('reload');
							}else{
								$.messager.alert('��ʾ','ɾ��ʧ��:'+ret);
							}
						}
					});
				}
            }
        },'-',{
            text:'����',
            iconCls: 'icon-save',
            handler: function(){
                SaveGridData('tabColCfgList','User.DHCDocCTDefineColCfg');
            }
        }],
        columns:[[ 
            {field:'ID',hidden:true}, 
            {field:'DefineDR',hidden:true},
            {field:'Code',title:'����',width:100,editor:{type:'text'}},    
            {field:'Name',title:'����',width:120,editor:{type:'text'}},    
            {field:'Active',title:'����',width:50,align:'center',
                editor:{type:'checkbox',options:{on:'Y',off:''}}
            },
            {field:'Sequence',title:'˳��',width:50,align:'center',
                editor:{type:'numberbox',options:{min:1}}
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
	    	$.messager.popover({msg:"����'"+Code+"'�ظ�ά��",type:'error'});
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
            $.messager.popover({msg:"���������Ʋ���Ϊ��",type:'alert'});
            return;
        }
        SaveRows.push(row);
    }
    if(!SaveRows||!SaveRows.length){
        $.messager.popover({msg:"û����Ҫ���������",type:'alert'});
        return;
    }
    var ret=tkMakeServerCall('DHCDoc.Diagnos.SpecLocTemp','SaveData',tableName,JSON.stringify(SaveRows));
    if(ret=='0'){
        $.messager.popover({msg:"����ɹ�",type:'success'});
        $('#'+id).datagrid('reload');
    }else{
        $.messager.alert('��ʾ','����ʧ��:'+ret);
    }
}