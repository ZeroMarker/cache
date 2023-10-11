$(function(){
    InitFavType();
    InitCatList();
    InitItemList();
    InitSyndList();
    InitMenu();
});
function InitFavType()
{
    var FavTypeData=$.cm({
		ClassName:'DHCDoc.Diagnos.Fav',
		MethodName:'GetFavTypeJSON',
		CONTEXT:ServerObj.CONTEXT, 
		LocID:session['LOGON.CTLOCID'],
		UserID:session['LOGON.USERID'],
		EditMode:'Y'
	},false);
    $("#kwFavType").keywords({
        singleSelect:true,
        items:FavTypeData,
        onClick:function(){
            $('#tabCatList').datagrid('reload');
            var Type=GetCatType();
            DisableToolbar('tabCatList',!ServerObj.FavAuth[Type]);
            DisableToolbar('tabItemList',!ServerObj.FavAuth[Type]);
            DisableToolbar('tabSyndList',!ServerObj.FavAuth[Type]);
            if(ServerObj.FavAuth[Type]) $('#BSaveItemToCat').linkbutton('enable');
            else $('#BSaveItemToCat').linkbutton('disable');
        }
    });
}
function InitCatList()
{
    var SavedFlag=false;
    $('#tabCatList').datagrid({
        border:false,
        columns:[[ 
            {field:'ID',hidden:true},    
            {field:'Name',title:'����',width:120,editor:{type:'text'}}
        ]],
        toolbar:[{
            text:'����',
            iconCls: 'icon-add',
            handler: function(){
                $('#tabCatList').datagrid('appendRow',{});
                var rows= $('#tabCatList').datagrid('getRows');
                $('#tabCatList').datagrid('beginEdit',rows.length-1).datagrid('scrollTo',rows.length-1);
            }
        },{
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
                            ClassName:'DHCDoc.Diagnos.Fav',
                            MethodName:'DeleteCat',
                            ID:Selected.ID,
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
        },{
            text:'����',
            iconCls: 'icon-save',
            handler: function(){
                var SaveRows=$('#tabCatList').datagrid('getEditRows');
                $.each(SaveRows,function(index,row){
                    if(row.Name==""){
                        SaveRows.splice(index,1);
                    }
                });
                if(!SaveRows.length){
                    $.messager.popover({msg:'û����Ҫ���������',type:'alert'});
                    return
                }
                var ret=$.cm({
					ClassName:'DHCDoc.Diagnos.Fav',
					MethodName:'SaveCats',
					Type:GetCatType(),
					CONTEXT:ServerObj.CONTEXT, 
					LocID:session['LOGON.CTLOCID'],
					UserID:session['LOGON.USERID'],
                    SaveRows:JSON.stringify(SaveRows),
					dataType:'text'
				},false);
				if(ret=='0'){
                    SavedFlag=true;
					$.messager.popover({msg:'����ɹ�',type:'success'});
                    $('#tabCatList').datagrid('reload');
				}else{
					$.messager.alert('��ʾ','����ʧ��:'+ret,'warning');
				}
            }
        },{
            text:'����',
            iconCls: 'icon-arrow-top',
            handler: function(){
                MoveDataGridRow('tabCatList','UP','UpdateCatSeq');
            }
        },{
            text:'����',
            iconCls: 'icon-arrow-bottom',
            handler: function(){
                MoveDataGridRow('tabCatList','DOWN','UpdateCatSeq');
            }
        }],
        onBeforeLoad:function(param){
            param.ClassName='DHCDoc.Diagnos.Fav';
            param.QueryName='QueryCat';
            param.Type=GetCatType(); 
            param.LocID=session['LOGON.CTLOCID'];
            param.UserID=session['LOGON.USERID']; 
            param.CONTEXT=ServerObj.CONTEXT;
            if($('#tabItemList').hasClass('datagrid-f'))
                $('#tabItemList,#tabSyndList').datagrid('loadData',[]);
        },
        onSelect:function(index, row){
            $('#tabItemList').datagrid('reload');
        },
        onDblClickRow:function(index, row){
            var Type=GetCatType();
            if(!ServerObj.FavAuth[Type]){
                $.messager.popover({msg:"û��ά��Ȩ��",type:'alert'});
                return;
            }
            $(this).datagrid('beginEdit',index);
        },
        onBeginEdit:function(index, row){
            var ed = $(this).datagrid('getEditor', {index:index,field:'Name'});
            $(ed.target).select().keyup(function(e){
                if((e.keyCode==13)&&($(this).getValue()!="")){
                    $('#tabCatList').datagrid('options').toolbar[2].handler();
                }
            });
        },
        onRowContextMenu:function(e,index,row){
            e.preventDefault();
            $(this).datagrid('selectRow',index);
            if(row.ID){
                $('#menu').menu('show',{left:e.pageX,top:e.pageY});
            }
        },
		onLoadSuccess:function(data){
            $(this).prev().find('.datagrid-body').find('div.datagrid-cell').overflowtip();
            if(SavedFlag){
                $(this).datagrid('options').toolbar[0].handler();
                SavedFlag=false;
            }
		}
    });
}
function GetCatType()
{
	return "User."+$("#kwFavType").keywords('getSelected')[0].id;
}
function InitItemList()
{
    var SavedFlag=false;
    $('#tabItemList').datagrid({
        border:false,
        columns:[[ 
            {field:'ID',hidden:true},  
            {field:'ICDRowid',hidden:true}, 
            {field:'Type',title:'����',width:50,editor:{
                    type:'combobox',
                    options:{
                        url:'',
                        editable:false,
                        panelHeight:'auto',
                        data:[{id:0,text:$g('��ҽ')},{id:1,text:$g('��ҽ')}],
                        onChange:function(val,oldVal){
	                    	if(oldVal!=''){
                                var index=GetDGEditRowIndex(this);
                                var eds = $('#tabItemList').datagrid('getEditors',index);
					            $(eds[2].target).lookup('setValue','').lookup('setText','').focus();
                                $(eds[4].target).val('');
		                    }
	                    },
                        onSelect:function(rec){
                            if(!rec) return;
                            if(ServerObj.SDSDiagEntry){
                                var index=GetDGEditRowIndex(this);
                                var eds = $('#tabItemList').datagrid('getEditors',index);
                                var id='ICDDesc_'+index;
                                $(eds[2].target).attr('id',id);
                                InitDiagnosICDDescLookUp(id,rec.id+'^'+ServerObj.PAAdmType);
                            }
                        }
                    }
                },
                formatter: function(value,row,index){
                    switch (parseInt(value)) {
						case 2:return $g('֤��');
						case 1:return $g('��ҽ');
						default:return $g('��ҽ');
					}
                }
            },   
            {field:'Prefix',title:'ǰ׺',width:100,editor:{type:'text'},hidden:ServerObj.SDSDiagEntry}, 
            {field:'ICDDesc',title:'�������',valueField:'ICDRowid',width:130,editor:{type:'text' }},   
            {field:'Note',title:'��ע',width:100,editor:{type:'text'}}, 
            {field:'SDSInfo',hidden:true,editor:{type:'text'}}
        ]],
        toolbar:[{
            text:'����',
            iconCls: 'icon-add',
            handler: function(){
                var selected=$('#tabCatList').datagrid('getSelected');
                if(!selected){
                    $.messager.popover({msg:"��ѡ��ģ�����",type:'alert'});
                    return false;
                }
                if(!selected.ID){
	            	$.messager.popover({msg:"���ȱ���ģ�����",type:'alert'});
                    return false;
	            }
                $('#tabItemList').datagrid('appendRow',{});
                var rows= $('#tabItemList').datagrid('getRows');
                $('#tabItemList').datagrid('beginEdit',rows.length-1).datagrid('scrollTo',rows.length-1);
            }
        },{
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
                            ClassName:'DHCDoc.Diagnos.Fav',
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
        },{
            text:'����',
            iconCls: 'icon-save',
            handler: function(){
                var selected=$('#tabCatList').datagrid('getSelected');
                if(!selected) return false;
                var CatID=selected.ID;
                var SaveRows=$('#tabItemList').datagrid('getEditRows');
                $.each(SaveRows,function(index,row){
                    if(!row.ICDRowid&&!row.Note){
                        SaveRows.splice(index,1);
                    }
                });
                if(!SaveRows.length){
                    $.messager.popover({msg:'û����Ҫ���������',type:'alert'});
                    return
                }
                var ret=$.cm({
					ClassName:'DHCDoc.Diagnos.Fav',
					MethodName:'SaveItems',
                    CatID:CatID,
					UserID:session['LOGON.USERID'],
                    SaveRows:JSON.stringify(SaveRows),
					dataType:'text'
				},false);
				if(ret=='0'){
                    SavedFlag=true;
					$.messager.popover({msg:'����ɹ�',type:'success'});
                    $('#tabItemList').datagrid('reload');
				}else{
					$.messager.alert('��ʾ','����ʧ��:'+ret,'warning');
				}
            }
        },{
            text:'����',
            iconCls: 'icon-arrow-top',
            handler: function(){
                MoveDataGridRow('tabItemList','UP','UpdatItemSeq');
            }
        },{
            text:'����',
            iconCls: 'icon-arrow-bottom',
            handler: function(){
                MoveDataGridRow('tabItemList','DOWN','UpdatItemSeq');
            }
        }],
        onBeforeLoad:function(param){
            var selected=$('#tabCatList').datagrid('getSelected');
            if(!selected) return false;
            param.ClassName='DHCDoc.Diagnos.Fav';
            param.QueryName='QueryItem';
            param.CatID=selected.ID; 
            if($('#tabSyndList').hasClass('datagrid-f'))
                $('#tabSyndList').datagrid('loadData',[]);
        },
        onSelect:function(index, row){
            var Type=row.Type;
            if(Type=='0'){
                DisableToolbar('tabSyndList',true);
                $('#tabSyndList').datagrid('loadData',[]);
                return false;
            }
            DisableToolbar('tabSyndList',!ServerObj.FavAuth[GetCatType()]);
            $('#tabSyndList').datagrid('reload');
        },
        onDblClickRow:function(index, row){
            var Type=GetCatType();
            if(!ServerObj.FavAuth[Type]){
                $.messager.popover({msg:"û��ά��Ȩ��",type:'alert'});
                return;
            }
            $(this).datagrid('beginEdit',index);
        },
        onBeginEdit:function(index, row){
            var defType=row.Type;
            if(typeof(defType)=='undefined'){
                defType=0;
                var prevIndex=index-1;
                if(prevIndex>-1){
                    var rows=$(this).datagrid('getRows');
                    var prevEds=$(this).datagrid('getEditors',prevIndex);
                    defType=prevEds.length?$(prevEds[0].target).combobox('getValue'):rows[prevIndex].Type;
                }
            }
            var eds = $(this).datagrid('getEditors',index);
            $(eds[0].target).combobox('select',defType);
            if(!ServerObj.SDSDiagEntry){
                InitItemLookUp(index);
            }else{
                EditSDSExpProperty(index);
                $(eds[2].target).click(function(){
                    EditSDSExpProperty(index);
                });
            }
            $(eds[2].target).setValue(row.ICDRowid,row.ICDDesc).select();
            $(eds[1].target).keyup(rowKeyupHandle);
            $(eds[3].target).keyup(rowKeyupHandle);
            function rowKeyupHandle(e){
                if(e.keyCode==13){
                    if(($(eds[2].target).getValue()!="")||($(eds[3].target).getValue()!="")){
                        $('#tabItemList').datagrid('options').toolbar[2].handler();
                    }else{
                        $(this).closest('td[field]').next().find('input:enabled').eq(0).select();
                    }
                }
            }
        },
		onLoadSuccess:function(data){
            $(this).prev().find('.datagrid-body').find('div.datagrid-cell').overflowtip();
            if(SavedFlag){
                $(this).datagrid('options').toolbar[0].handler();
                SavedFlag=false;
            }
		}
    });
}
function InitSyndList()
{
    var SavedFlag=false;
    $('#tabSyndList').datagrid({
        border:false,
        columns:[[ 
            {field:'ID',hidden:true},  
            {field:'SyndromeID',hidden:true},   
            {field:'SyndDesc',title:'֤������',valueField:'SyndromeID',width:120,editor:{
                    type:'lookup',
                    options:{
                        url:$URL,
                        mode:'remote',
                        method:"Get",
                        idField:'HIDDEN',
                        textField:'desc',
                        columns:[[  
                            {field:'desc',title:'�������',width:300,sortable:true},
                            {field:'code',title:'code',width:120,sortable:true},
                            {field:'HIDDEN',hidden:true}
                        ]],
                        pagination:true,
                        panelWidth:500,
                        panelHeight:410,
                        isCombo:true,
                        minQueryLen:2,
                        delay:'500',
                        queryOnSameQueryString:true,
                        queryParams:{ClassName: 'web.DHCMRDiagnos',QueryName: 'LookUpWithAlias'},
                        onBeforeLoad:function(param){
                            var desc=param['q'];
                            param = $.extend(param,{desc:desc,ICDType:2});
                        },
                        onSelect:function(){
                            $('#tabSyndList').datagrid('options').toolbar[2].handler();
                        }
                    }
                }
            },   
            {field:'Note',title:'��ע',width:100,editor:{type:'text'}}
        ]],
        toolbar:[{
            text:'����',
            iconCls: 'icon-add',
            handler: function(){
                var selected=$('#tabItemList').datagrid('getSelected');
                if(!selected){
                    $.messager.popover({msg:"��ѡ��ģ����Ŀ",type:'alert'});
                    return false;
                }
                if(!selected.ID){
	            	$.messager.popover({msg:"���ȱ��������Ŀ",type:'alert'});
                    return false;
	            }
	            if(selected.Type!='1'){
		        	$.messager.popover({msg:"����ҽ��ϣ�����ά��֤��",type:'alert'});
                    return false;
		        }
                $('#tabSyndList').datagrid('appendRow',{});
                var rows= $('#tabSyndList').datagrid('getRows');
                $('#tabSyndList').datagrid('beginEdit',rows.length-1).datagrid('scrollTo',rows.length-1);
            }
        },{
            text:'ɾ��',
            iconCls: 'icon-remove',
            handler: function(){
                var Selected= $('#tabSyndList').datagrid('getSelected');
                if(!Selected){
                    $.messager.popover({msg:"��ѡ����Ҫɾ��������",type:'alert'});
                    return;
                }
                if(!Selected.ID){
	                var index=$('#tabSyndList').datagrid('getRowIndex',Selected);
	                $('#tabSyndList').datagrid('deleteRow',index);
	            	return;
	            }
                $.messager.confirm('��ʾ','ȷ��ɾ��ѡ������?',function(r){
                    if(r){
                        var ret=$.cm({
                            ClassName:'DHCDoc.Diagnos.Fav',
                            MethodName:'DeleteSyndrome',
                            ID:Selected.ID,
                            dataType:'text'
                        },false);
                        if(ret=='0'){
                            $.messager.popover({msg:"ɾ���ɹ�",type:'success'});
                            $('#tabSyndList').datagrid('reload');
                        }else{
                            $.messager.alert('��ʾ','ɾ��ʧ��:'+ret);
                        }
                    }
                });
            }
        },{
            text:'����',
            iconCls: 'icon-save',
            handler: function(){
                var selected=$('#tabItemList').datagrid('getSelected');
                if(!selected) return false;
                var ItemID=selected.ID;
                var SaveRows=$('#tabSyndList').datagrid('getEditRows');
                $.each(SaveRows,function(index,row){
                    if(!row.SyndromeID&&!row.Note){
                        SaveRows.splice(index,1);
                    }
                });
                if(!SaveRows.length){
                    $.messager.popover({msg:'û����Ҫ���������',type:'alert'});
                    return
                }
                var ret=$.cm({
					ClassName:'DHCDoc.Diagnos.Fav',
					MethodName:'SaveSyndromes',
                    ItemID:ItemID,
					UserID:session['LOGON.USERID'],
                    SaveRows:JSON.stringify(SaveRows),
					dataType:'text'
				},false);
				if(ret=='0'){
                    SavedFlag=true;
					$.messager.popover({msg:'����ɹ�',type:'success'});
                    $('#tabSyndList').datagrid('reload');
				}else{
					$.messager.alert('��ʾ','����ʧ��:'+ret,'warning');
				}
            }
        },{
            text:'����',
            iconCls: 'icon-arrow-top',
            handler: function(){
                MoveDataGridRow('tabSyndList','UP','UpdatSyndromeSeq');
            }
        },{
            text:'����',
            iconCls: 'icon-arrow-bottom',
            handler: function(){
                MoveDataGridRow('tabSyndList','DOWN','UpdatSyndromeSeq');
            }
        }],
        onBeforeLoad:function(param){
            var selected=$('#tabItemList').datagrid('getSelected');
            if(!selected) return false;
            param.ClassName='DHCDoc.Diagnos.Fav';
            param.QueryName='QuerySyndromeNew';
            param.ItemID=selected.ID; 
        },
        onDblClickRow:function(index, row){
            var Type=GetCatType();
            if(!ServerObj.FavAuth[Type]){
                $.messager.popover({msg:"û��ά��Ȩ��",type:'alert'});
                return;
            }
            $(this).datagrid('beginEdit',index);
        },
        onBeginEdit:function(index, row){
            var eds = $(this).datagrid('getEditors',index);
            $(eds[0].target).setValue(row.SyndromeID,row.SyndDesc).select();
            $(eds[1].target).keyup(function(e){
                if((e.keyCode==13)&&(($(this).getValue()!="")||($(eds[0].target).getValue()!=""))){
                    $('#tabSyndList').datagrid('options').toolbar[2].handler();
                }
            });
        },
		onLoadSuccess:function(data){
            $(this).prev().find('.datagrid-body').find('div.datagrid-cell').overflowtip();
            if(SavedFlag){
                $(this).datagrid('options').toolbar[0].handler();
                SavedFlag=false;
            }
		}
    });
}
function DisableToolbar(id,disable)
{
    if(disable){
        $('#'+id).parent().prev('.datagrid-toolbar').find('a.l-btn').linkbutton('disable');
    }else{
        $('#'+id).parent().prev('.datagrid-toolbar').find('a.l-btn').linkbutton('enable');
    }
}
function MoveDataGridRow(id,arrow,MethodName)
{
	var $dg=$('#'+id);
    var curRow=$dg.datagrid('getSelected');
    if(!curRow){
        $.messager.popover({msg:'��ѡ����Ҫ�ƶ�����!',type:'alert'});
        return;
    }
    var index=$dg.datagrid('getRowIndex',curRow);
    var eds=$dg.datagrid('getEditors',index);
    if(eds.length){
		$.messager.popover({msg:'��ǰ��δ����,�����ƶ�!',type:'alert'});
        return;
    }
    var columns=new Array();
    switch(id){
        case 'tabCatList':
            columns=['ID','Name'];
            break;
        case 'tabItemList':
            columns=['ID','Prefix','ICDDesc','Note'];
            break;
        case 'tabSyndList':
            columns=['ID','SyndDesc','Note'];
            break;
        default:break;
    }
    if(columns.length){
        $dg.datagrid('removeInvalidEditRow',columns);
    }
    if($dg.datagrid('isEditing')){
		$.messager.popover({msg:'����������ڱ༭����!',type:'alert'});
        return;
	}
    var rows=$dg.datagrid('getRows');
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
    $dg.datagrid('refreshRow',index).datagrid('refreshRow',changeIndex).datagrid('selectRow',changeIndex);
    var idArr=new Array();
    for(var i=0;i<rows.length;i++){
        var ID=rows[i].ID;
        if(ID) idArr.push(ID);
    }
    var selectedCat=$('#tabCatList').datagrid('getSelected');
    var CatID=selectedCat?selectedCat.ID:'';
    var selectedItem=$('#tabItemList').datagrid('getSelected');
    var ItemID=selectedItem?selectedItem.ID:'';
    var ret=$.cm({
        ClassName:'DHCDoc.Diagnos.Fav',
        MethodName:MethodName,
        CatID:CatID,
        ItemID:ItemID,
        UserID:session['LOGON.USERID'],
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
function InitMenu()
{
    $('#menu').menu({
        onShow:function(){
            var Type=GetCatType();
            $(this).find('div[key]').each(function(){
	            var key=$(this).attr('key');
                if((Type==key)||!ServerObj.FavAuth[key]){
                    $('#menu').menu('disableItem',this);
                }else{
                    $('#menu').menu('enableItem',this);
                }
            });
        },
        onClick:function(item){
            var Selected= $('#tabCatList').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"��ѡ����Ҫ���Ƶķ���",type:'alert'});
                return;
            }
            var Type=$(item.target).attr('key');
            var LocID=$(item.target).attr('locid');
	        if(Type){
	            var ret=$.cm({
	                ClassName:'DHCDoc.Diagnos.Fav',
	                MethodName:'CopyCat',
	                FromCatID:Selected.ID,
	                Type:Type,
	                CONTEXT:ServerObj.CONTEXT, 
	                LocID:session['LOGON.CTLOCID'],
	                UserID:session['LOGON.USERID'],
	                dataType:'text'
	            },false);
	            if(ret=='0'){
	                $.messager.popover({msg:'���Ƴɹ�',type:'success'});
	            }else{
	                $.messager.alert('��ʾ','����ʧ��:'+ret,'warning');
	            }
            }else if(LocID){
	        	var ret=$.cm({
	                ClassName:'DHCDoc.Diagnos.Fav',
	                MethodName:'CopyCat',
	                FromCatID:Selected.ID,
	                Type:'User.CTLoc',
	                CONTEXT:ServerObj.CONTEXT, 
	                LocID:LocID,
	                UserID:session['LOGON.USERID'],
	                dataType:'text'
	            },false);
	            if(ret=='0'){
	                $.messager.popover({msg:'���Ƴɹ�',type:'success'});
	            }else{
	                $.messager.alert('��ʾ','����ʧ��:'+ret,'warning');
	            }
	        }
        }
    });
}
function SaveItemToCat()
{
	var Selected= $('#tabCatList').datagrid('getSelected');
    if(!Selected){
        $.messager.popover({msg:"��ѡ��Ŀ�����",type:'alert'});
        return;
    }
    if(!Selected.ID){
        $.messager.popover({msg:"��ѡ����Ч�ķ���",type:'alert'});
        return;
    }
    var opts=websys_showModal('options');
    var ItemData=opts.ItemData;
	var ret=$.cm({
		ClassName:'DHCDoc.Diagnos.Fav',
		MethodName:'SaveItems',
        CatID:Selected.ID,
		UserID:session['LOGON.USERID'],
        SaveRows:JSON.stringify(ItemData),
		dataType:'text'
	},false);
	if(ret=='0'){
		if(opts.callBackFun) opts.callBackFun();
		websys_showModal('close');
	}else{
		$.messager.alert('��ʾ','����ʧ��:'+ret,'warning');
	}
}
function InitItemLookUp(index)
{
    var eds=$('#tabItemList').datagrid('getEditors',index);
    $(eds[2].target).lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Rowid',
        textField:'ICDDesc',
        columns:[[  
            {field:'ICDDesc',title:'�������',width:300,sortable:false},
            {field:'ICDCode',title:'��ϴ���',width:120,sortable:false},
            {field:'Rowid',hidden:true}
        ]],
        pagination:true,
        pageList:[7,15,30,50,100],
        pageSize:7,
        panelWidth:500,
        panelHeight:305,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.Diagnos.Common',QueryName: 'QueryICD'},
        onBeforeLoad:function(param){
            var desc=param['q'];
            var DiaType=$(eds[0].target).combobox('getValue');
            $.extend(param,{desc:desc,EpisodeID:'',ICDType:DiaType});
        },
        onSelect:function(){
            $('#tabItemList').datagrid('options').toolbar[2].handler();
        }
    });
}
//CDSS���ѡ��ص�
function CDSSPropertyConfirmCallBack(resWordICD,DomID){
	var SDSSArr=resWordICD.split("^");
	var SDSDesc=SDSSArr[1];
	if(SDSDesc=="") SDSDesc=SDSSArr[7];
	var ICDRowid=SDSSArr[8];
	if(ICDRowid==''){
		$.messager.alert('���ʧ��',SDSDesc+' δ����ICD���');
		return
	}
	var index=DomID.split("_")[1];
    var eds = $('#tabItemList').datagrid('getEditors',index);
    $(eds[2].target).lookup('setValue',ICDRowid).lookup('setText',SDSDesc);
	var SDSInfo=SDSSArr[0]?"^"+SDSSArr[0]+"^"+SDSSArr[2]+"^"+SDSSArr[4]+"^"+SDSSArr[3]:"";
    $(eds[4].target).val(SDSInfo);
    $('#tabItemList').datagrid('options').toolbar[2].handler();
}
//CDSS���ȡ��ѡ��ص�
function CDSSPropertyCcancelfirmCallBack(DomID){
    var index=DomID.split("_")[1];
    var eds = $('#tabItemList').datagrid('getEditors',index);
    var row=$('#tabItemList').datagrid('getRows')[index];
    if(row.ID){
        $('#tabItemList').datagrid('cancelEdit',index);
    }else{
        $(eds[2].target).lookup('setValue','').lookup('setText','');
        $(eds[4].target).val('');
    }
}
function EditSDSExpProperty(index)
{
   if(!ServerObj.SDSDiagEntry) return;
   var eds = $('#tabItemList').datagrid('getEditors',index);
   var SDSInfo=$(eds[4].target).val();
   if(!SDSInfo) return;
   var SDSInfoArr=SDSInfo.split("^");
   var SDSRowId=SDSInfoArr[0];
   var SDSTermDR=SDSInfoArr[1];
   var SDSValue=SDSInfoArr[2];
   var SDSWordID=SDSInfoArr[3];
   var Supplement=SDSInfoArr[4];
   var ICDType=$(eds[0].target).combobox('getValue');
   InSDSExpProperty(SDSRowId,SDSTermDR,Supplement,$(eds[2].target),SDSValue,SDSWordID,ICDType+'^'+ServerObj.PAAdmType);
}