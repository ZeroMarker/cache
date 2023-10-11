$(function(){
    InitWorkflowCat();
    InitWorkflowItem();
});
function InitWorkflowCat()
{
    $('#tabCatList').datagrid({
        border:false,
        fitColumns:false,
        columns:[[ 
            {field:'ID',hidden:true},    
            {field:'Name',title:'����',width:600,editor:{type:'text'}},
            {field:'AuthHospIDs',hidden:true},    
            {field:'AuthLocIDs',hidden:true},    
            {field:'AuthGroupIDs',hidden:true}
        ]],
        toolbar:[{
            text:'����',
            iconCls: 'icon-add',
            handler: function(){
                $('#tabCatList').datagrid('appendRow',{});
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
                $.messager.confirm('��ʾ','ȷ��ɾ��ѡ������?',function(r){
                    if(r){
                        var ret=$.cm({
                            ClassName:'DHCDoc.OPDoc.Workflow',
                            MethodName:'DeleteCat',
                            CatID:Selected.ID,
                            dataType:'text'
                        },false);
                        if(ret=='0'){
                            $.messager.popover({msg:"ɾ���ɹ�",type:'success'});
                            $('#tabCatList').datagrid('reload');
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
                var SaveRows=new Array();
                var rows= $('#tabCatList').datagrid('getRows');
                for(var i=0;i<rows.length;i++){
                    var Editors=$('#tabCatList').datagrid('getEditors',i);
                    if(!Editors.length) continue;
                    var row=rows[i];
                    if(!row.ID) row.ID="";
                    row.Name=$(Editors[0].target).val();
                    if(row.Name=='') continue;
                    SaveRows.push(row);
                }
                if(!SaveRows.length){
                    $.messager.popover({msg:'û����Ҫ���������',type:'alert'});
                    return
                }
                var ret=$.cm({
					ClassName:'DHCDoc.OPDoc.Workflow',
					MethodName:'SaveCats',
					UserID:session['LOGON.USERID'],
                    SaveRows:JSON.stringify(SaveRows),
					dataType:'text'
				},false);
				if(ret=='0'){
					$.messager.popover({msg:'����ɹ�',type:'success'});
                    $('#tabCatList').datagrid('reload');
				}else{
					$.messager.alert('��ʾ','����ʧ��:'+ret,'warning');
				}
            }
        },'-',{
            text:'����',
            iconCls: 'icon-arrow-top',
            handler: function(){
                MoveDataGridRow('tabCatList','UP','UpdateCatSeq');
            }
        },'-',{
            text:'����',
            iconCls: 'icon-arrow-bottom',
            handler: function(){
                MoveDataGridRow('tabCatList','DOWN','UpdateCatSeq');
            }
        },'-',{
            text:'��Ȩ',
            iconCls: 'icon-attachment',
            handler: function(){
                var Selected= $('#tabCatList').datagrid('getSelected');
                if(!Selected||!Selected.ID){
                    $.messager.popover({msg:"��ѡ����Ҫ��Ȩ������",type:'alert'});
                    return;
                }
                InitAuthDialog();
            }
        },'-',{
            text:'ά��˵��',
            iconCls: 'icon-help',
            handler: function(){
                $('#winHelp').window('open');
            }
        }],
        onBeforeLoad:function(param){
            param.ClassName='DHCDoc.OPDoc.Workflow';
            param.QueryName='QueryCat';
            if($('#tabItemList').hasClass('datagrid-f'))
                $('#tabItemList').datagrid('loadData',[]);
        },
        onSelect:function(index, row){
            $('#tabItemList').datagrid('reload');
        },
        onDblClickRow:function(index, row){
            $(this).datagrid('beginEdit',index);
        },
        onBeginEdit:function(index, row){
            var ed = $(this).datagrid('getEditor', {index:index,field:'Name'});
            $(ed.target).select();
        },
        onRowContextMenu:function(e,index,row){
            e.preventDefault();
            $(this).datagrid('selectRow',index);
            if(row.ID){
                $('#menu').menu('show',{left:e.pageX,top:e.pageY});
            }
        }
    });
}
function InitWorkflowItem()
{
    $('#tabItemList').datagrid({
        border:false,
        fitColumns:false,
        columns:[[ 
            {field:'ID',hidden:true},
            {field:'Code',title:'����',width:200,editor:{type:'text'}},   
            {field:'Name',title:'����',width:200,editor:{type:'text'}},   
            {field:'ClickEvent',title:'����¼�',width:220,editor:{type:'text'}},   
            {field:'Link',title:'����',width:400,editor:{type:'text'}}, 
            {field:'Express',title:'���ʽ',width:250,editor:{type:'text'}},   
            {field:'XRefresh',title:'�ֲ�ˢ��',align:'center',width:60,
                editor:{type:'checkbox',options:{on:1,off:0}},
                formatter: function(value,row,index){
                    return (value==true)||(value==1)?'��':'��';
                },
                styler: function(value,row,index){
                    return (value==true)||(value==1)?'color:#21ba45;':'color:#f16e57;';
                }
            },    
            {field:'Active',title:'����',align:'center',width:60,
                editor:{type:'checkbox',options:{on:1,off:0}},
                formatter: function(value,row,index){
                    return (value==true)||(value==1)?'��':'��';
                },
                styler: function(value,row,index){
                    return (value==true)||(value==1)?'color:#21ba45;':'color:#f16e57;';
                }
            },    
            {field:'PreLineClass',title:'ǰ����ʽ',width:150,editor:{type:'text'}}
        ]],
        toolbar:[{
            text:'����',
            iconCls: 'icon-add',
            handler: function(){
                var selected=$('#tabCatList').datagrid('getSelected');
                if(!selected){
                    $.messager.popover({msg:"��ѡ�����",type:'alert'});
                    return false;
                }
                $('#tabItemList').datagrid('appendRow',{Active:1});
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
                            ClassName:'DHCDoc.OPDoc.Workflow',
                            MethodName:'DeleteItem',
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
                var selected=$('#tabCatList').datagrid('getSelected');
                if(!selected) return false;
                var CatID=selected.ID;
                var SaveRows=new Array();
                var rows= $('#tabItemList').datagrid('getRows');
                for(var i=0;i<rows.length;i++){
                    var Editors=$('#tabItemList').datagrid('getEditors',i);
                    if(!Editors.length) continue;
                    var row=rows[i];
                    if(!row.ID) row.ID="";
                    row.Code=$(Editors[0].target).val();
                    row.Name=$(Editors[1].target).val();
                    if(!row.Code&&!row.Name) continue;
                    if(row.Code==''){
	                    $.messager.popover({msg:'���벻��Ϊ��',type:'alert'});
	                    $(Editors[0].target).focus();
	                	return false;
	                }
	                if(row.Name==''){
	                    $.messager.popover({msg:'��������Ϊ��',type:'alert'});
	                    $(Editors[1].target).focus();
	                	return false;
	                }
                    row.ClickEvent=$(Editors[2].target).val();
                    row.Link=$(Editors[3].target).val();
                    row.Express=$(Editors[4].target).val();
                    row.XRefresh=$(Editors[5].target).is(':checked')?1:0;
                    row.Active=$(Editors[6].target).is(':checked')?1:0;
                    row.PreLineClass=$(Editors[7].target).val();
                    SaveRows.push(row);
                }
                if(!SaveRows.length){
                    $.messager.popover({msg:'û����Ҫ���������',type:'alert'});
                    return
                }
                var ret=tkMakeServerCall('DHCDoc.OPDoc.Workflow','SaveItems',CatID,JSON.stringify(SaveRows),session['LOGON.USERID']);
				if(ret=='0'){
					$.messager.popover({msg:'����ɹ�',type:'success'});
                    $('#tabItemList').datagrid('reload');
				}else{
					$.messager.alert('��ʾ','����ʧ��:'+ret,'warning');
				}
            }
        },'-',{
            text:'����',
            iconCls: 'icon-arrow-top',
            handler: function(){
                MoveDataGridRow('tabItemList','UP','UpdatItemSeq');
            }
        },'-',{
            text:'����',
            iconCls: 'icon-arrow-bottom',
            handler: function(){
                MoveDataGridRow('tabItemList','DOWN','UpdatItemSeq');
            }
        }],
        onBeforeLoad:function(param){
            var selected=$('#tabCatList').datagrid('getSelected');
            if(!selected) return false;
            param.ClassName='DHCDoc.OPDoc.Workflow';
            param.QueryName='QueryCatItem';
            param.CatID=selected.ID;
        },
        onSelect:function(index, row){
        },
        onDblClickRow:function(index, row){
            $(this).datagrid('beginEdit',index);
        },
        onBeginEdit:function(index, row){
        }
    });
}
function MoveDataGridRow(id,arrow,MethodName)
{
    var curRow=$('#'+id).datagrid('getSelected');
    if(!curRow){
        $.messager.popover({msg:'��ѡ����Ҫ�ƶ�����!',type:'alert'});
        return;
    }
    var index=$('#'+id).datagrid('getRowIndex',curRow);
    var rows=$('#'+id).datagrid('getRows');
    var changeIndex=-1;
    if(arrow=='UP'){
        if(index==0){
            $.messager.popover({msg:'���ǵ�һ��!',type:'alert'});
            return false;
        }
        changeIndex=index-1;
    }else{
        if(index==(rows.length-1)){
            $.messager.popover({msg:'�������һ��!',type:'alert'});
            return false;
        }
        changeIndex=index+1;
    }
    rows[index]=rows[changeIndex];
    rows[changeIndex]=curRow;
    $('#'+id).datagrid('refreshRow',index).datagrid('refreshRow',changeIndex).datagrid('selectRow',changeIndex);
    var idArr=new Array();
    for(var i=0;i<rows.length;i++){
        var ID=rows[i].ID;
        if(ID) idArr.push(ID);
    }
    var selectedCat=$('#tabCatList').datagrid('getSelected');
    var CatID=selectedCat?selectedCat.ID:'';
    var ret=$.cm({
        ClassName:'DHCDoc.OPDoc.Workflow',
        MethodName:MethodName,
        CatID:CatID,
        IDStr:JSON.stringify(idArr),
        dataType:'text'
    },false);
    if(ret=='0'){
        //$.messager.popover({msg:'λ�õ����ɹ�',type:'success'});
    }else{
        $.messager.alert('��ʾ','λ�õ���ʧ��:'+ret,'warning');
    }
    return true;
}
function InitAuthDialog()
{
    var Selected=$('#tabCatList').datagrid('getSelected');
    var title='['+Selected.Name+'] ��Ȩ';
    if(!$('#_Auth_Dialog').size()){
		$('body').append('<div id="_Auth_Dialog" style="overflow:hidden;"></div>');
		$('#_Auth_Dialog').dialog({ 
            title:title, 
            iconCls:'icon-attachment',
			width: 1100,    
			height: 655,    
			content:'',  
			modal: true,
			buttons:[{
				text:'������Ȩ',
				iconCls: 'icon-w-save',
				handler:function(){
                    var AuthData=new Array();
                    $('.auth-container table.datagrid-f').each(function(){
                        var SaveArr=new Array();
                        var checkedRows = $(this).datagrid('getChecked');
                        for(var i=0;i<checkedRows.length;i++){
                            SaveArr.push(checkedRows[i].id);
                        }
                        AuthData.push(SaveArr);
                    });
                    var HospIDs=JSON.stringify(AuthData[0]);
                    var LocIDs=JSON.stringify(AuthData[1]);
                    var GroupIDs=JSON.stringify(AuthData[2]);
                    var Selected=$('#tabCatList').datagrid('getSelected');
                    var ret=$.cm({
                        ClassName:'DHCDoc.OPDoc.Workflow',
                        MethodName:'SaveCatAuth',
                        CatID:Selected.ID,
                        HospIDs:HospIDs, 
                        LocIDs:LocIDs, 
                        GroupIDs:GroupIDs,
                        dataType:'text'
                    },false);
                    if(ret=='0'){
                        $.messager.popover({msg:"��Ȩ�ɹ�",type:'success'});
                        $('#_Auth_Dialog').dialog('close');
                        var index=$('#tabCatList').datagrid('getRowIndex',Selected);
                        $.extend(Selected,{AuthHospIDs:HospIDs,AuthLocIDs:LocIDs,AuthGroupIDs:GroupIDs});
                        $('#tabCatList').datagrid('updateRow',{index:index,row:Selected});
                    }else{
                        $.messager.alert('��ʾ','ɾ��ʧ��:'+ret);
                    }
				}
			}]  
		}).dialog('open'); 
        InitAuthDataGrid();
    }else{
        $('#_Auth_Dialog').dialog('setTitle',title).dialog('open');
        SetAuthData();
    }
    
}
function InitAuthDataGrid()
{
    var $body=$('#_Auth_Dialog').dialog('body');
    var $content=$body.children('.panel').children('.panel-body');
    $content.addClass('auth-container');
    var DataGridConfig=[{title:'ҽԺ',QueryName:'QueryHosp'},{title:'����',QueryName:'QueryLoc'},{title:'��ȫ��',QueryName:'QueryGroup'}];
    var SuccessCount=0;
    $.each(DataGridConfig,function(){
        var title=this.title;
        var QueryName=this.QueryName;
        var $datagrid=$('<table></table>');
        var $input=$('<input type="text"></input>').addClass('textbox').attr('placeholder','������'+title+'��������...').css('width','95%');
        $('<div class="one-unit"></div>').append($('<div></div>').append($input)).append($('<div></div>').append($datagrid)).appendTo($content);
        $datagrid.datagrid({
            idField:'id',
            singleSelect:false,
            rownumbers:false,
            border:false,
            columns:[[ 
                {field:'id',hidden:true}, 
                {field:'check',checkbox:true},   
                {field:'text',title:'����',width:600}
            ]],
            onBeforeLoad:function(param){
                param.ClassName='DHCDoc.OPDoc.Workflow';
                param.QueryName=QueryName;
            },
            onLoadSuccess:function(){
                if(++SuccessCount==3){
                    SetAuthData();
                }
            }
        });
        var searchTimer;
        $input.keyup(function(e){
            clearTimeout(searchTimer);
            searchTimer=setTimeout(function(){
                filterDataGrid($datagrid,$input);
            },200);
        });
    });
}
function filterDataGrid($datagrid,$input)
{
	var desc=$input.val().toUpperCase();
	var rows=$datagrid.datagrid('getRows');
	var trObj=$datagrid.datagrid('getPanel').find('.datagrid-view2').find('table.datagrid-btable').find('tr');
	for(var i=0;i<rows.length;i++){
		if((rows[i].code.toUpperCase().indexOf(desc)==-1)&&(rows[i].text.toUpperCase().indexOf(desc)==-1)){
			trObj.eq(i).hide();
		}else{
			trObj.eq(i).show();
		}
	}
}
function SetAuthData()
{
    var Selected=$('#tabCatList').datagrid('getSelected');
    var AuthData=new Array();
    AuthData.push(Selected.AuthHospIDs==''?[]:JSON.parse(Selected.AuthHospIDs));
    AuthData.push(Selected.AuthHospIDs==''?[]:JSON.parse(Selected.AuthLocIDs));
    AuthData.push(Selected.AuthHospIDs==''?[]:JSON.parse(Selected.AuthGroupIDs));
    $('.auth-container table.datagrid-f').each(function(index){
	    var $input=$(this).closest('.one-unit').children('div:first').children('input');
	    if($input.val()!=""){
		    $input.val('');
			filterDataGrid($(this),$input);
		}
        var rows=$(this).datagrid('getRows');
		for(var i=0;i<rows.length;i++){
			if(AuthData[index].indexOf(rows[i].id)>-1){
				$(this).datagrid('checkRow',i);
			}else{
				$(this).datagrid('uncheckRow',i);
			}
		}
    });
}