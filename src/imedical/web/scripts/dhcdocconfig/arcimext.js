var PageLogicObj={
    'User.DHCItmConflict':{
        'ITCConflictType':[{id:'',text:''},{id:'R',text:'��'},{id:'F',text:'η'}],
        'ITCShortConflictType':[{id:'',text:''},{id:'DT',text:'��������'},{id:'AT',text:'���ξ�������'},{id:'DF',text:'���ս���'},{id:'AF',text:'���ξ������'}],
        'ITCLongConflictType':[{id:'',text:''},{id:'DT',text:'��������'},{id:'AT',text:'���ξ�������'},{id:'S',text:'ֹͣ'},{id:'DF',text:'���ս���'},{id:'AF',text:'���ξ������'}]
    }
};
$(function(){
    $.extend(GenHospComp("DHC_ItmMast").jdata.options,{
        onSelect:function(index,row){
            $('#tabArcimList').datagrid('load');
        },
        onLoadSuccess:function(data){
            InitSearchBox();
            InitArcimGrid();
            InitConflictGrid();
            InitReplaceGrid();
            InitStopDefDate();
            InitTip();
            InitCombo();
            InitEvent();
        }
    });
});
function InitEvent(){
    $('#BSave').click(SaveData);
    $('#DARCIMStopAfterLongOrder').checkbox({
        onCheckChange:function(e,value){
            if(value){
                $('#DARCIMAllowLongOrder').checkbox('enable');
            }else{
                $('#DARCIMAllowLongOrder').checkbox('disable').checkbox('setValue',false);
            }
        }
    });
}
function InitCombo(){
    $("#DARCIMSpecLocDiag").combobox({
		valueField:'Code', textField:'Name',panelHeight:"auto",
		mode:'remote',
		url:$URL+"?ClassName=DHCDoc.Diagnos.SpecLocTemp&QueryName=QueryCat&ResultSetType=array"
	});
}
function InitArcimGrid(){
    var toolbar=[{
		text:'����',
		iconCls: 'icon-add',
		handler: function(){
            $('#tabArcimList').datagrid('appendRow',{});
            var rows= $('#tabArcimList').datagrid('getRows');
            $('#tabArcimList').datagrid('beginEdit',rows.length-1);
		}
	},'-',{
		text:'ɾ��',
		iconCls: 'icon-remove',
		handler: function(){
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"��ѡ����Ҫɾ��������",type:'alert'});
                return;
            }
            if(Selected.ID){
                $.messager.confirm('��ʾ','ȷ��ɾ����������?',function(r){
                    if(r){
                        var ret=$.cm({
                            ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
                            MethodName:'DeleteData',
                            ClsName:'User.DHCItmMast',
                            ID:Selected.ID,
                            dataType:'text'
                        },false);
                        if(ret=='0'){
                            $.messager.popover({msg:"ɾ���ɹ�",type:'success'});
                            $('#tabArcimList').datagrid('load');
                        }else{
                            $.messager.alert('��ʾ','ɾ��ʧ��:'+ret);
                        }
                    }
                });
            }else{
                var index=$('#tabArcimList').datagrid('getRowIndex',Selected);
                $('#tabArcimList').datagrid('deleteRow',index);
            }
		}
	},'-',{
		text:'����',
		iconCls: 'icon-save',
		handler: function(){
            var SaveRows=$('#tabArcimList').datagrid('getEditRows');
            if(!SaveRows.length){
                $.messager.popover({msg:"û����Ҫ���������",type:'alert'});
                return;
            }
            var ret=$.cm({
                ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
                MethodName:'SaveData',
                ClsNameStr:JSON.stringify(['User.DHCItmMast']),
                InputStr:JSON.stringify([SaveRows]),
                dataType:'text'
            },false);
            if(ret=='0'){
                $.messager.popover({ msg: '����ɹ�!',type:'success'});
                $('#tabArcimList').datagrid('load');
            }else{
                $.messager.alert('��ʾ','����ʧ��:'+ret);
            }
		}
	},'-',{
		text:'����',
		iconCls: 'icon-export',
		handler: function(){
            $.messager.progress({text:'������...'});
            $cm({
                ResultSetType:"ExcelPlugin",  //��ʾͨ��DLL����Excel����֧��IE��Chromeϵ��Chromeϵ������밲װ�м��
                //ResultSetTypeDo:"Print",    //Ĭ��Export����������Ϊ��PRINT , PREVIEW
                localDir:"Self",	      //D:\\tmp\\��ʾ�̶��ļ�·��, "Self"��ʾ�û�����ʱѡ�񱣴�·����Ĭ�ϱ��浽����
                ExcelName:"ҽ������չ�趨",		  //Ĭ��DHCCExcel�����ð�����׺
                PageName:"ARCIMEXT",      //��ʾ���ĸ�����ĵ�������ֹͬһQuery������治ͬ����, �����ý���PAGENAMEһ��
                ClassName:"DHCDoc.DHCDocConfig.ARCIMExt",
                QueryName:"QueryItemToExcel",
                HospID:$('#_HospList').getValue(),
                Alias:$('#SearchItem').searchbox('getValue')
            },function(){
                $.messager.progress('close');
            });
        }
    }];
    $('#tabArcimList').datagrid({
        pagination:true,
        pageSize:15,
		pageList : [15,50,100,200],
        toolbar:toolbar,
        columns:[[
            {field:'ID',hidden:true}, 
            {field:'ARCIMRowid',hidden:true},
            {field:'ARCIMDesc',title:'ҽ������',width:200,valueField:'DARCIMARCIMDR',
                editor:{
                    type:'lookup',
                    options:{
                        url:$URL,
                        mode:'remote',
                        method:"Get",
                        idField:'ArcimRowID',
                        textField:'ARCIMDesc',
                        columns:[[  
                            {field:'ARCIMDesc',title:'����',width:320,sortable:true},
                            {field:'ArcimRowID',title:'ID',width:70,sortable:true}
                        ]],
                        pagination:true,
                        panelWidth:400,
                        panelHeight:400,
                        isCombo:true,
                        minQueryLen:2,
                        delay:'500',
                        queryOnSameQueryString:true,
                        queryParams:{ClassName: 'web.DHCARCOrdSets',QueryName: 'LookUpItem'},
                        onBeforeLoad:function(param){
                            param = $.extend(param,{Item:param['q'],GroupID:'',OrderPrescType:"Other",HospID:$('#_HospList').getValue()});    //:session['LOGON.GROUPID']
                        }
                    }
                }
            },
            {field:'CNMedFlag',title:'�Ƿ��ҩ',width:55,align:'center',
                styler: function(value,row,index){
                    return value?'color:#21ba45;':'color:#f16e57;';
                },
                formatter:function(value,record){
                    return value?'��':'��';
                }
            }
        ]],
        onSelect:function(index,row){
            InitData();
        },
        onBeginEdit:function(index,row){
            var ed = $(this).datagrid('getEditor', {index:index,field:'ARCIMDesc'});
            $(ed.target).focus();
        },
        queryParams:{ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',QueryName:'QueryItmMast'},
        onBeforeLoad:function(param){
            param.Alias=$('#SearchItem').searchbox('getValue');
            param.HospID=$('#_HospList').getValue();
            param.ArcimID="";
            var rows=$(this).datagrid('getRows');
            if(rows.length){
                var Editors=$(this).datagrid('getEditors',rows.length-1);
                if(Editors.length)  param.ArcimID=$(Editors[0].target).getValue();
            }
            $(this).datagrid('unselectAll');
            $('#tabConflict,#tabItemReplace').setData([]);
        },
        onLoadSuccess:function(data){
            if(data.rows.length==1){
                $(this).datagrid('selectRow',0);
            }
        }
    });
}
function InitSearchBox()
{
    $('#SearchItem').searchbox({
        prompt:'��������Ŀ����...',
        searcher:function(value,name){
            $('#tabArcimList').datagrid('load');
        }
    });
}
function InitData()
{
    var row=$('#tabArcimList').datagrid('getSelected');
    if(!row) return;
    $('#tabConflict,#tabItemReplace').datagrid('load');
    $('body>.layout-panel-center').showMask();
    $.cm({
        ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
        MethodName:'GetRowData',
        ClsName:'User.DHCItmMast', RowID:row.ID
    },function(data){
        $.each(data, function(id, value) {
            $('#'+id).setValue(value);
        });
        $('body>.layout-panel-center').hideMask();
    });
}
function InitStopDefDate(){
    $('#DARCIMStopDefSttDateDay').numberbox({
        min:0,
        max:9,
        onChange:function(val){
            if(val>0){
                $('#DARCIMStopDefSttTime').timespinner('setValue','08:00:00').timespinner('enable');
            }else{
                $('#DARCIMStopDefSttTime').timespinner('setValue','').timespinner('disable');
            }
        }
    })
}
function InitConflictGrid(){
    var toolbar=[{
		text:'����',
		iconCls: 'icon-add',
		handler: function(){
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"��ѡ��ҽ����Ŀ",type:'alert'});
                return;
            }
            $('#tabConflict').datagrid('appendRow',{ITCParRef:Selected.ID});
            var rows= $('#tabConflict').datagrid('getRows');
            $('#tabConflict').datagrid('beginEdit',rows.length-1);
		}
	},'-',{
		text:'�޸�',
		iconCls: 'icon-edit',
		handler: function(){
            var Selected= $('#tabConflict').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"��ѡ����Ҫ�޸���Ŀ",type:'alert'});
                return;
            }
            var index= $('#tabConflict').datagrid('getRowIndex',Selected);
            $('#tabConflict').datagrid('beginEdit',index);
		}
	},'-',{
		text:'ɾ��',
		iconCls: 'icon-remove',
		handler: function(){
            var Selected= $('#tabConflict').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"��ѡ����Ҫɾ��������",type:'alert'});
                return;
            }
            if(Selected.ID){
                $.messager.confirm('��ʾ','ȷ��ɾ����������?',function(r){
                    if(r){
                        var ret=$.cm({
                            ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
                            MethodName:'DeleteData',
                            ClsName:'User.DHCItmConflict',
                            ID:Selected.ID,
                            dataType:'text'
                        },false);
                        if(ret=='0'){
                            $.messager.popover({msg:"ɾ���ɹ�",type:'success'});
                            $('#tabConflict').datagrid('load');
                        }else{
                            $.messager.alert('��ʾ','ɾ��ʧ��:'+ret);
                        }
                    }
                });
            }else{
                var index=$('#tabConflict').datagrid('getRowIndex',Selected);
                $('#tabConflict').datagrid('deleteRow',index);
            }
		}
	},'-',{
        id:'btnConflictHelp',
		iconCls: 'icon-help'
    }];
    $('#tabConflict').datagrid({
        idField:'ID',
        pagination:false,
        toolbar:toolbar,
        columns:[[
            {field:'ITCParRef',hidden:true}, 
            {field:'ID',hidden:true}, 
            {field:'ITCConflictItmDR',hidden:true},
            {field:'ARCIMDesc',title:'ҽ������',width:200,valueField:'ITCConflictItmDR',
                editor:{
                    type:'lookup',
                    options:{
                        url:$URL,
                        mode:'remote',
                        method:"Get",
                        idField:'ArcimRowID',
                        textField:'ARCIMDesc',
                        columns:[[  
                            {field:'ARCIMDesc',title:'����',width:320,sortable:true},
                            {field:'ArcimRowID',title:'ID',width:70,sortable:true}
                        ]],
                        pagination:true,
                        panelWidth:400,
                        panelHeight:400,
                        isCombo:true,
                        minQueryLen:2,
                        delay:'500',
                        queryOnSameQueryString:true,
                        queryParams:{ClassName: 'web.DHCARCOrdSets',QueryName: 'LookUpItem'},
                        onBeforeLoad:function(param){
                            param = $.extend(param,{Item:param['q'],GroupID:'',OrderPrescType:"Other",HospID:$('#_HospList').getValue()});    //:session['LOGON.GROUPID']
                        }
                    }
                }
            },
            {field:'ITCShortConflictType',title:'��ʱ�������(�ǲ�ҩʹ��)',width:70,align:'center',
                editor:{
                    type:'combobox',
                    options:{
                        url:'',
                        editable:false,
                        data:PageLogicObj['User.DHCItmConflict']['ITCShortConflictType']
                    }
                },
                formatter: function(value,row,index){
                    return GetPropTextByVal('User.DHCItmConflict','ITCShortConflictType',value);
                }
            },
            {field:'ITCLongConflictType',title:'���ڻ������(�ǲ�ҩʹ��)',width:70,align:'center',
                editor:{
                    type:'combobox',
                    options:{
                        url:'',
                        editable:false,
                        data:PageLogicObj['User.DHCItmConflict']['ITCLongConflictType']
                    }
                },
                formatter: function(value,row,index){
                    return GetPropTextByVal('User.DHCItmConflict','ITCLongConflictType',value);
                }
            },
            {field:'ITCConflictType',title:'����(��ҩʹ��)',width:70,align:'center',
                editor:{
                    type:'combobox',
                    options:{
                        url:'',
                        editable:false,
                        data:PageLogicObj['User.DHCItmConflict']['ITCConflictType']
                    }
                },
                formatter: function(value,row,index){
                    return GetPropTextByVal('User.DHCItmConflict','ITCConflictType',value);
                }
            }
        ]],
        onBeginEdit:function(index,row){
            var Editors=$('#tabConflict').datagrid('getEditors',index);
            $(Editors[0].target).setValue(row.ITCConflictItmDR,row.ARCIMDesc).select();
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(Selected.CNMedFlag){
                $(Editors[1].target).combobox('disable');
                $(Editors[2].target).combobox('disable');
                $(Editors[3].target).combobox('enable');
            }else{
                $(Editors[1].target).combobox('enable');
                $(Editors[2].target).combobox('enable');
                $(Editors[3].target).combobox('disable');
            }
        },
        queryParams:{ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',QueryName:'QueryConflict'},
        onDblClickRow:function(index, row){
            $(this).datagrid('beginEdit',index);
        },
        onBeforeLoad:function(param){
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(!Selected) return false;
            param.ITCParRef=Selected.ID;
            $(this).datagrid('unselectAll');
        }
    });
}
function InitReplaceGrid(){
    var toolbar=[{
		text:'����',
		iconCls: 'icon-add',
		handler: function(){
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"��ѡ��ҽ����Ŀ",type:'alert'});
                return;
            }
            $('#tabItemReplace').datagrid('appendRow',{IRParRef:Selected.ID});
            var rows= $('#tabItemReplace').datagrid('getRows');
            $('#tabItemReplace').datagrid('beginEdit',rows.length-1);
		}
	},'-',{
		text:'�޸�',
		iconCls: 'icon-edit',
		handler: function(){
            var Selected= $('#tabItemReplace').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"��ѡ����Ҫ�޸���Ŀ",type:'alert'});
                return;
            }
            var index= $('#tabItemReplace').datagrid('getRowIndex',Selected);
            $('#tabItemReplace').datagrid('beginEdit',index);
		}
	},'-',{
		text:'ɾ��',
		iconCls: 'icon-remove',
		handler: function(){
            var Selected= $('#tabItemReplace').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"��ѡ����Ҫɾ��������",type:'alert'});
                return;
            }
            if(Selected.ID){
                $.messager.confirm('��ʾ','ȷ��ɾ����������?',function(r){
                    if(r){
                        var ret=$.cm({
                            ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
                            MethodName:'DeleteData',
                            ClsName:'User.DHCItmReplace',
                            ID:Selected.ID,
                            dataType:'text'
                        },false);
                        if(ret=='0'){
                            $.messager.popover({msg:"ɾ���ɹ�",type:'success'});
                            $('#tabItemReplace').datagrid('load');
                        }else{
                            $.messager.alert('��ʾ','ɾ��ʧ��:'+ret);
                        }
                    }
                });
            }else{
                var index=$('#tabItemReplace').datagrid('getRowIndex',Selected);
                $('#tabItemReplace').datagrid('deleteRow',index);
            }
		}
	}];
    $('#tabItemReplace').datagrid({
        idField:'ID',
        pagination:false,
        toolbar:toolbar,
        columns:[[
            {field:'IRParRef',hidden:true}, 
            {field:'ID',hidden:true}, 
            {field:'IRReplaceItmDR',hidden:true},
            {field:'ARCIMDesc',title:'ҽ������',width:200,valueField:'IRReplaceItmDR',
                editor:{
                    type:'lookup',
                    options:{
                        url:$URL,
                        mode:'remote',
                        method:"Get",
                        idField:'ArcimRowID',
                        textField:'ARCIMDesc',
                        columns:[[  
                            {field:'ARCIMDesc',title:'����',width:320,sortable:true},
                            {field:'ArcimRowID',title:'ID',width:70,sortable:true}
                        ]],
                        pagination:true,
                        panelWidth:400,
                        panelHeight:400,
                        isCombo:true,
                        minQueryLen:2,
                        delay:'500',
                        queryOnSameQueryString:true,
                        queryParams:{ClassName: 'web.DHCARCOrdSets',QueryName: 'LookUpItem'},
                        onBeforeLoad:function(param){
                            param = $.extend(param,{Item:param['q'],GroupID:'',OrderPrescType:"Other",HospID:$('#_HospList').getValue()});    //:session['LOGON.GROUPID']
                        }
                    }
                }
            },
            {field:'IRReplaceExpress',title:'�滻����(m������ʽ)',width:150,
                editor:{type:'text'}
            }
        ]],
        onBeginEdit:function(index,row){
            var ed = $(this).datagrid('getEditor', {index:index,field:'ARCIMDesc'});
            $(ed.target).setValue(row.IRReplaceItmDR,row.ARCIMDesc).select();
        },
        queryParams:{ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',QueryName:'QueryReplace'},
        onDblClickRow:function(index, row){
            $(this).datagrid('beginEdit',index);
        },
        onBeforeLoad:function(param){
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(!Selected) return false;
            param.IRParRef=Selected.ID;
            $(this).datagrid('unselectAll');
        }
    });
}
function SaveData(){
    var row=$('#tabArcimList').datagrid('getSelected');
    if(!row){
        $.messager.popover({ msg: '��ѡ����Ҫ�����ҽ��',type:'alert'});
        return;
    }
    var SaveDataArr=[GetNorData(),GetConflictData(),GetReplaceData()];
    var ClsArr=['User.DHCItmMast','User.DHCItmConflict','User.DHCItmReplace'];
    if(!CheckBeforeSave(SaveDataArr)) return;
    var ret=$.cm({
        ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
        MethodName:'SaveData',
        ClsNameStr:JSON.stringify(ClsArr),
        InputStr:JSON.stringify(SaveDataArr),
        dataType:'text'
    },false);
    if(ret=='0'){
        $.messager.popover({ msg: '����ɹ�!',type:'success'});
        $('#tabConflict,#tabItemReplace').datagrid('load');
    }else{
        $.messager.alert('��ʾ','����ʧ��:'+ret);
    }
}
function GetNorData(){
    var row=$('#tabArcimList').datagrid('getSelected');
    var SaveObj=$.extend({},row);
    $('[clsName="User.DHCItmMast"]').find('[id]').each(function(){
        var id=$(this).attr('id');
        var val=$(this).getValue();
        SaveObj[id]=val;
    });
    return [SaveObj];
}
function GetConflictData(){
    var SaveRows=$('#tabConflict').datagrid('getEditRows');
    return SaveRows;
}
function GetReplaceData(){
    var SaveRows=$('#tabItemReplace').datagrid('getEditRows');
    return SaveRows;
}
function CheckBeforeSave(SaveDataArr)
{
    var Selected= $('#tabArcimList').datagrid('getSelected');
    var CNMedFlag=Selected.CNMedFlag;
    if(CNMedFlag){
        var ConflictData=SaveDataArr[1];
        for(var i=0;i<ConflictData.length;i++){
            if(!ConflictData[i].ITCConflictType){
                $.messager.popover({msg:"��ѡ���ҩ"+ConflictData[i].ARCIMDesc+" �Ļ�������",type:'alert'});
                return false;
            }
        }
    }
    var ReplaceData=SaveDataArr[2];
    for(var i=0;i<ReplaceData.length;i++){
        if(!ReplaceData[i].IRReplaceExpress){
            $.messager.popover({msg:ReplaceData[i].ARCIMDesc+"�滻������Ϊ��",type:'alert'});
            return false;
        }
    }
    return true;
}
function GetPropTextByVal(ClsName,PropName,val)
{
    var text="";
    $.each(PageLogicObj[ClsName][PropName],function(){
        if(this.id==val){
            text=this.text;
            return false;
        }
    });
    return text;
}
function InitTip(){
    $.fn.tooltip.defaults.onShow=function(){
        $('.combobox-f').combobox('hidePanel');
    }
    $("#btnConflictHelp").tooltip({
		content:"<ul class='tip_class'><li style='font-weight:bold'>ҽ����������ʹ��˵��</li>" + 
                '<li>1��[���ڻ����������ʱ�������]���������˵�ҽ��������</li>' +
                '<li>2�����һ����Ŀ���ڶ��������Ŀ,������Ŀ֮��Ļ���ȡ���Ƽ�����ߵ���Ŀ���йܿ�</li>'+
                '<li>3����������������ȼ�:���ξ������>���ս���>ֹͣ(����Ĭ��)>���ξ�������>��������(��ʱĬ��)</li>'+
                "</ul>"
	});
    $("#tipRepeatCheckDays").tooltip({
		content:"���������󽫼����������о������������ڵ�ҽ��,������ֻ������ǰ�����¼"
	});
	$("#tipConflic").tooltip({
		content:"<ul class='tip_class'><li style='font-weight:bold'>ҽ����������ʹ��˵��</li>" + 
                '<li>1������:���ѡ����Ŀ���·��������ڵ���Ŀ����,�������ڲ���Ŀ֮�䲻����</li>' +
                '<li>2��˫��(Ĭ��):���ѡ����Ŀ���·��������ڵ���Ŀ����,�������ڲ���Ŀ֮��Ҳ����</li>'+
                "</ul>"
	});
    $('#tipStopLongOrd').tooltip({
        content:"<ul class='tip_class'><li style='font-weight:bold'>����˵��</li>" +
            "<li>1��today������,����Ĭ�����ں���ҽ��¼��ʱ�Զ�����Ĭ�����ݵ�ҽ����ʼ�����С�</li>" +
            "<li>2��Ĭ�����������Ӧ���ڵ���0,Ϊ��ҵ����밴��0����Ĭ��ʱ����дʱӦ����00:00:00��</li>"+
            "</ul>"
    });
    $('#DARCIMNotLimitQty').next().after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'
    }).tooltip({
        content:'�����鲻��������Ϊ1,����ҽ���������������Ϊ9999'
    }));
    $("#tipSpecLocDiag").tooltip({
		content:"ר�Ʊ�Ӧ���������뵥�����������뵥���������뵥������ҩ�����뵥�����������̵ĵ�������Ӧ�ã�����ʹ��ר�Ʊ�������������Ӧ�ó����������ò���ר�Ʊ�������Ȩ����"
	});
    $('.datagrid-header-row .datagrid-cell:not(.datagrid-sort-icon)').overflowtip();
}