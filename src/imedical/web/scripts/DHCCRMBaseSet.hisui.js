//����    DHCCRMBaseSet.hisui.js
//����    ��û���ά��
//����    2020-11-11
//������  yupeng

var editIndex=undefined;

function ClickRow(index){
    
        if(editIndex != undefined)
        {
             $.messager.alert('��ʾ',"���ȵ���޸ı������ݣ�","error");
             return false;
        }
        
        if (editIndex!=index) {
            if (endEditing()){
                $('#FUSGroupTab').datagrid('selectRow',index).datagrid('beginEdit',index);
                editIndex = index;
            } else {
                $('#FUSGroupTab').datagrid('selectRow',editIndex);
            }
        }
}

function endEditing(){
            if (editIndex == undefined){return true}
            if ($('#FUSGroupTab').datagrid('validateRow', editIndex)){
                
                var ed = $('#FUSGroupTab').datagrid('getEditor',{index:editIndex,field:'GroupID'});
                var name = $(ed.target).combobox('getText');
                $('#FUSGroupTab').datagrid('getRows')[editIndex]['GroupDesc'] = name;
                
                
                
                $('#FUSGroupTab').datagrid('endEdit', editIndex);
                
                editIndex = undefined;
                return true;
            } else {
                return false;
            }
}



$(function(){
    
    InitFUSubjectTabDataGrid();
    InitFUSDetailTabDataGrid();
    InitFUSICDTabDataGrid();
    InitFUSLocTabDataGrid();
    InitFUSGroupTabDataGrid();
    InitFUSDSelectTabDataGrid();
    InitFUSDSTemplateTabDataGrid();   
    
    var LinkDetailObj = $HUI.combobox("#LinkDetail",{
        url:$URL+"?ClassName=web.DHCCRM.CRMBaseSet&QueryName=SearchFUSDetail&ResultSetType=array",
        valueField:'RowId',
        textField:'Code',
        multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
        rowStyle:'checkbox',
        onBeforeLoad:function(param){
            param.fusrowid = $("#FUSID").val()
        },
        onShowPanel:function()
        {
          $(this).combobox('reload'); 
        } 
          
    });
    
    var ExclusiveDetailObj = $HUI.combobox("#ExclusiveDetail",{
        url:$URL+"?ClassName=web.DHCCRM.CRMBaseSet&QueryName=SearchFUSDetail&ResultSetType=array",
        valueField:'RowId',
        textField:'Code',
        multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
        rowStyle:'checkbox',
        onBeforeLoad:function(param){
            param.fusrowid = $("#FUSID").val()
        },
        onShowPanel:function()
        {
          $(this).combobox('reload'); 
        } 
          
    });
    
    var SubjectObj = $HUI.combobox("#Subject",{
        url:$URL+"?ClassName=web.DHCCRM.CRMBaseSet&QueryName=SearchFUSubject&SubLevel=1&ResultSetType=array",
        valueField:'RowId',
        textField:'alldesc',
        panelHeight:'auto',
        editable:false,
        onShowPanel:function()
        {
          $(this).combobox('reload');  
            
        }
    }); 
    //����(����)
    $('#add_btn').click(function(e){
        AddData();
    });
    
    //�޸�(����)
     $('#update_btn').click(function(){
        UpdateData();
    });
   
    //����(��������)
    $('#FUSDadd_btn').click(function(e){
        FUSDAddData();
    });
    //�޸�(��������)
     $('#FUSDupdate_btn').click(function(){
        FUSDUpdateData();
    });
    //����(����ѡ��)
    $('#FUSDSadd_btn').click(function(e){
        FUSDSAddData();
    });
    //�޸�(����ѡ��)
     $('#FUSDSupdate_btn').click(function(){
        FUSDSUpdateData();
    });
    //ɾ��(����ѡ��)
     $('#FUSDSdel_btn').click(function(){
        FUSDSDelData();
    });
    //����(ICD)
     $('#FUSICDImport_btn').click(function(){
        FUSICDImport();
    });
    //����(����)
     $('#FUSLocImport_btn').click(function(){
        FUSLocImport();
    }); 
    
    //ɾ��(ICD)
     $('#FUSICDDel_btn').click(function(){
        FUSICDDel();
    });
    //ɾ��(����)
     $('#FUSLocDel_btn').click(function(){
        FUSLocDel();
    });
    
     $("#Limit").checkbox({
        
            onCheckChange:function(e,value){
                if(value)
                {
                   $("#Begin").datebox('enable');
                   $("#End").datebox('enable');
                }
                else
                {
                   $("#Begin").datebox('disable');
                   $("#End").datebox('disable');
                    
                }
                            
            }
     });
        
        
    var SubjectObj = $HUI.combobox("#Subject",{
        url:$URL+"?ClassName=web.DHCCRM.CRMBaseSet&QueryName=SearchFUSubject&ResultSetType=array",
        valueField:'RowId',
        textField:'alldesc',
        onBeforeLoad:function(param){
            param.showFlag="Parent";
        }
        })
    
})
//�������
function InitFUSubjectTabDataGrid() {
    $HUI.treegrid("#FUSubjectTab",{
        url: $URL,
        fit: true,
        border: false,
        fitColumns: true,
        rownumbers: true,
        animate: true,
        singleSelect: true,
        idField: 'RowId',
        treeField: 'Desc',
        queryParams:{
            ClassName:"web.DHCCRM.CRMBaseSet",
            QueryName:"SearchFUSubject",
            page:1,
            rows:500
        },
        columns:[[
            {field:'RowId',title:'RowId',hidden:true},
            {field:'Code',title:'����'},
            {field:'Desc',title:'����'},
            {field:'Level',title:'����', formatter:function(data, value, index) {
                return data=="3"?"����":(data=="2"?"����":(data=="1"?"һ��":""));
            }},
            {field:'Limit',title:'��������',formatter:function(data, value, index) {
                return data=="Y"?"��":"��";
            }},
            {field:'Begin',title:'��ʼ����'}, 
            {field:'End',title:'��������'}, 
            {field:'Active',title:'����',formatter:function(data, value, index) {
                return data=="Y"?"��":"��";}},       
        ]],
        onSelect: function (rowIndex, rowData) {
            editIndex=undefined;
            $("#FUSID").val(rowData.RowId);
            
            if(rowData.Active=="Y")
            {
                /*
                $("#update_btn").linkbutton('disable');
                $("#FUSDupdate_btn").linkbutton('disable');
                $("#FUSDSupdate_btn").linkbutton('disable');
                $("#FUSDSdel_btn").linkbutton('disable');
                $("#FUSDSadd_btn").linkbutton('disable');
                $("#FUSDadd_btn").linkbutton('disable');
                */
            }
            else
            {
                $("#update_btn").linkbutton('enable');
                $("#FUSDupdate_btn").linkbutton('enable');
                $("#FUSDSupdate_btn").linkbutton('enable');
                $("#FUSDSdel_btn").linkbutton('enable');
                $("#FUSDSadd_btn").linkbutton('enable');
                $("#FUSDadd_btn").linkbutton('enable');
                
            }
            
            if (rowData._parentId != "a") {
                $("#FUSDetailTab").datagrid('load', {
                    ClassName:"web.DHCCRM.CRMBaseSet",
                    QueryName:"SearchFUSDetail",
                    fusrowid:rowData.RowId
                });
                
                $("#FUSICDTab").datagrid('load', {
                    ClassName:"web.DHCCRM.CRMBaseSet",
                    QueryName:"SearchFUSICD",
                    fusrowid:rowData.RowId
                });
                
                $("#FUSLocTab").datagrid('load', {
                    ClassName:"web.DHCCRM.CRMBaseSet",
                    QueryName:"SearchFUSLoc",
                    fusrowid:rowData.RowId
                });
                
                $("#FUSGroupTab").datagrid('load', {
                    ClassName:"web.DHCCRM.CRMBaseSet",
                    QueryName:"SearchFUSGroup",
                    fusrowid:rowData.RowId
                });
                
                
            } else {
                $("#FUSDetailTab").datagrid('loadData', { total: 0, rows: [] });
                $("#FUSICDTab").datagrid('loadData', { total: 0, rows: [] });
                $("#FUSLocTab").datagrid('loadData', { total: 0, rows: [] });
                $("#FUSGroupTab").datagrid('loadData', { total: 0, rows: [] });
            }
            $("#FUSDSelectTab").datagrid('load',{
                ClassName:"web.DHCCRM.CRMBaseSet",
                QueryName:"SearchFUSDSelect",
                fusdrowid:""
                }); 
        },
        onLoadSuccess:function(data){

            $("#FUSubjectTab").datagrid("clearSelections");

        },
        onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
            $("#FUSubjectTab").treegrid("toggle",rowData.RowId);
        },
    });
}

function InitFUSLocTabDataGrid()
{
    $HUI.datagrid("#FUSLocTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        singleSelect: true,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCCRM.CRMBaseSet",
            QueryName:"SearchFUSLoc",
            fusrowid:""
        },
        
        columns:[[
            {field:'RowId',title:'ID',hidden: true},
            {field:'Code',title:'����'},
            {field:'Loc',title:'����'}
        ]],
        onSelect: function (rowIndex, rowData) {
         $("#FUSLocID").val(rowData.RowId); 
           
                    
        }
        
            
    })
    
}
function InitFUSGroupTabDataGrid()
{
    $HUI.datagrid("#FUSGroupTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        singleSelect: true,
        selectOnCheck: true,
        onClickRow: ClickRow,
        queryParams:{
            ClassName:"web.DHCCRM.CRMBaseSet",
            QueryName:"SearchFUSGroup",
            fusrowid:getValueById("FUSID")
        },
        
        columns:[[
            {field:'RowId',title:'ID',hidden: true},
            {field:'GroupID',title:'��ȫ��',width:200,
            formatter:function(value,row){
                        return row.GroupDesc;
                    },
            editor:{
                    type:'combobox',
                    options:{
                        valueField:'id',
                        textField:'desc',
                        method:'get',
                        url:$URL+"?ClassName=web.DHCCRM.CRMBaseSet&QueryName=FindFeeTypeSuperGroup&ResultSetType=array",
                        onBeforeLoad:function(param){
                            param.hospId = session['LOGON.HOSPID']; 
                            
                            }
                        
                    }
                }
            
            
            },
            {field:'Read',title:'�ɶ�',width:100,editor:{type:'icheckbox',options:{on:'Y',off:'N'}},formatter:function(data, value, index) {
                return data=="Y"?"��":"��";}},
            {field:'Write',title:'��д',width:100,editor:{type:'icheckbox',options:{on:'Y',off:'N'}},formatter:function(data, value, index) {
                return data=="Y"?"��":"��";}}
        ]],
        toolbar:[{
            iconCls:'icon-add',
            text:'����',
            handler: function(){
                
                
                
                if(editIndex != undefined)
                {
                    $.messager.alert("��ʾ","����δ��������ݣ������޸�!","info");    
                    return
                    
                }
                else
                {
                var rows = $("#FUSGroupTab").datagrid("getRows");
                $('#FUSGroupTab').datagrid('insertRow',{
                    index: 0,
                    row: {
                        RowId: '',
                        GroupID: '',
                        Read: '',
                        Write: ''
                        }
                });
                
                ClickRow(0);
                
                }
            }
        },{
            iconCls:'icon-write-order',
            text:'�޸�',
            handler: function(){
                endEditing();
            }
        }
        ],
        onAfterEdit:function(rowIndex,rowData,changes){
            
            var ID=rowData.RowId;
            var Group=rowData.GroupID;
            var Read=rowData.Read;
            var Write=rowData.Write;
            
            
            var flag=tkMakeServerCall("web.DHCCRM.CRMBaseSet","UpdateFUSGroup",ID,getValueById("FUSID"),Group,Read,Write);
            if (flag==0)
            {
                $("#FUSGroupTab").datagrid("load",{ClassName:"web.DHCCRM.CRMBaseSet",QueryName:"SearchFUSGroup",fusrowid:getValueById("FUSID")}); 

            }
            else 
            {
                $.messager.alert("��ʾ",flag,"info"); 
                $("#FUSGroupTab").datagrid("load",{ClassName:"web.DHCCRM.CRMBaseSet",QueryName:"SearchFUSGroup",fusrowid:getValueById("FUSID")}); 

            }
            
        },
         
        onSelect: function (rowIndex, rowData) {
         $("#FUSGroupID").val(rowData.RowId); 
           
                    
        }
        
            
    })
    
}
function InitFUSICDTabDataGrid()
{
     $HUI.datagrid("#FUSICDTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        singleSelect: true,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCCRM.CRMBaseSet",
            QueryName:"SearchFUSICD",
            fusrowid:""
        },
        
        columns:[[
            {field:'RowId',title:'ID',hidden: true},
            {field:'Code',title:'����'},
            {field:'Desc',title:'����'}
        ]],
        onSelect: function (rowIndex, rowData) {
         $("#FUSICDID").val(rowData.RowId); 
           
                    
        }
        
            
    })
    
    
}


//��������
function InitFUSDetailTabDataGrid()
{
    
    $HUI.datagrid("#FUSDetailTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        singleSelect: true,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCCRM.CRMBaseSet",
            QueryName:"SearchFUSDetail",
            fusrowid:""
        },
        
        columns:[[
            {field:'RowId',title:'ID',hidden: true},
            {field:'Code',title:'����'},
            {field:'Desc',title:'����'},
            {field:'Type',title:'����'}, 
            {field:'Unit',title:'��λ'}, 
            {field:'Explain',title:'˵��'}, 
            {field:'Sex',title:'�Ա�'},
            {field:'Active',title:'����',formatter:function(data, value, index) {
                return data=="Y"?"��":"��";}},
            {field:'EffDate',title:'��ʼ����'},
            {field:'EffDateTo',title:'��������'},
            {field:'Required',title:'����',formatter:function(data, value, index) {
                return data=="Y"?"��":"��";}},
            {field:'Sequence',title:'˳��'},    
            {field:'SelectNum',title:'����'}   
        ]],
        onSelect: function (rowIndex, rowData) {
         $("#FUSDID").val(rowData.RowId); 
         $("#FUSDSelectTab").datagrid('load', {
            ClassName:"web.DHCCRM.CRMBaseSet",
            QueryName:"SearchFUSDSelect",
            fusdrowid:rowData.RowId
        
            });
           
                    
        }
        
            
    })

}
//����ѡ��
function InitFUSDSelectTabDataGrid()
{
    
    $HUI.datagrid("#FUSDSelectTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        singleSelect: true,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCCRM.CRMBaseSet",
            QueryName:"SearchFUSDSelect",
            fusdrowid:""
        },
        columns:[[
            {field:'RowId',title:'ID',hidden: true},
            {field:'Text',title:'�ı�'},
            {field:'Unit',title:'��λ'}, 
            {field:'Default',title:'Ĭ��'},
            {field:'Sequence',title:'˳��'}   
        ]],
        onSelect: function (rowIndex, rowData) {
             $("#FUSDSID").val(rowData.RowId); 
           
                    
        }
        
            
    })

}

//����ѡ�����
function InitFUSDSTemplateTabDataGrid()
{
    
    $HUI.datagrid("#FUSDSTemplateTab",{
        url : $URL,
        fit : true,
        border : false,
        fitColumns:true,
        rownumbers : true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
        singleSelect: true,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCCRM.CRMBaseSet",
            QueryName:"SearchFUSDSTemplate",
            sdsrowid:$("#FUSDSID").val()
        },
        columns:[[
            {field:'RowId',title:'ID',hidden: true},
            {field:'Text',title:'��������'},
            {field:'Sequence',title:'˳��'}   
        ]],
        onSelect: function (rowIndex, rowData) {
             $("#FUSDSTID").val(rowData.RowId); 
           
                    
        }
        
            
    })

}
function FUSDUpdateData()
{
    var FUSID=$("#FUSID").val();
    if(FUSID==""){
        $.messager.alert('������ʾ',"��ѡ����޸ĵ������¼","info");
        return
    }
    
    var FUSDID=$("#FUSDID").val();
    if(FUSDID==""){
        $.messager.alert('������ʾ',"��ѡ����޸ĵ���������","info");
        return
    }
    
    if(FUSDID!="")
    {   
          var FUSStr=tkMakeServerCall("web.DHCCRM.CRMBaseSet","GetFUSDById",FUSDID);
           var FUSInfo=FUSStr.split("^");
           
           
           $("#SDCode").val(FUSInfo[0]);
           $("#SDDesc").val(FUSInfo[1]);
           setValueById("SDType",FUSInfo[2]);
           setValueById("SDUnit",FUSInfo[3]);
           setValueById("SDExplain",FUSInfo[4]);
           setValueById("SDSex",FUSInfo[5]);
           setValueById("SDEffDate",FUSInfo[7]);
           
           setValueById("SDEffDateTo",FUSInfo[8]);
           
           setValueById("SDSequence",FUSInfo[10]);
           setValueById("SDParentDR",FUSInfo[11]);
           setValueById("SDCascade",FUSInfo[12]);
           setValueById("SDSelectNum",FUSInfo[13]);
           
           
           if(FUSInfo[6]=="Y")
            $("#SDActive").checkbox('setValue',true);
           else 
            $("#SDActive").checkbox('setValue',false);
            
           if(FUSInfo[9]=="Y")
            $("#SDRequired").checkbox('setValue',true);
           else 
            $("#SDRequired").checkbox('setValue',false);
           
            $("#FUSDWin").show();
            
            var FUSDWin = $HUI.dialog("#FUSDWin",{
                iconCls:'icon-w-edit',
                resizable:true,
                title:'�޸�',
                modal:true,
                buttons:[{
                    text:'����',
                    id:'save_btn',
                    handler:function(){
                        SaveFUSDForm(FUSID,FUSDID)
                    }
                },{
                    text:'�ر�',
                    handler:function(){
                        FUSDWin.close();
                    }
                }]
            });                  
    }
    
    
    
    
}

function UpdateData()
{
    var FUSID=$("#FUSID").val();
    if(FUSID==""){
        $.messager.alert('������ʾ',"��ѡ����޸ĵ������¼","info");
        return
    }
    if(FUSID!="")
    {   
          var FUSStr=tkMakeServerCall("web.DHCCRM.CRMBaseSet","GetFUSById",FUSID);
           var FUSInfo=FUSStr.split("^");
           
           
           $("#Code").val(FUSInfo[0]);
           $("#Desc").val(FUSInfo[1]);
           setValueById("Begin",FUSInfo[3]);
           setValueById("End",FUSInfo[4]);
           
           if(FUSInfo[5]=="Y")
            $("#Active").checkbox('setValue',true);
           else 
            $("#Active").checkbox('setValue',false);
            
           if(FUSInfo[2]=="Y")
           {
            $("#Limit").checkbox('setValue',true);
            $("#Begin").datebox('enable');
            $("#End").datebox('enable');
           }
           else 
           {
               $("#Limit").checkbox('setValue',false);
               $("#Begin").datebox('disable');
                $("#End").datebox('disable');
           }
            
           
           setValueById("Level",FUSInfo[6]);
           setValueById("Subject",FUSInfo[7]);
           
            $("#myWin").show();
            
            var myWin = $HUI.dialog("#myWin",{
                iconCls:'icon-w-edit',
                resizable:true,
                title:'�޸�',
                modal:true,
                buttons:[{
                    text:'����',
                    id:'save_btn',
                    handler:function(){
                        SaveForm(FUSID)
                    }
                },{
                    text:'�ر�',
                    handler:function(){
                        myWin.close();
                    }
                }]
            });                         
    }
}


function FUSDAddData()
{
    
    var FUSID=$("#FUSID").val();
    if(FUSID==""){
        $.messager.alert('������ʾ',"����ѡ���ά��������","info");
        return
    }
    
    $("#FUSDWin").show();
     
        var FUSDWin = $HUI.dialog("#FUSDWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'����',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'����',
                id:'save_btn',
                handler:function(){
                    SaveFUSDForm(FUSID,"")
                }
            },{
                text:'�ر�',
                handler:function(){
                    FUSDWin.close();
                }
            }]
        });
        $('#fusd-save').form("clear");  
        $("#SDActive").checkbox('setValue',true);
}
function AddData()
{
    $("#myWin").show();
     
        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'����',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'����',
                id:'save_btn',
                handler:function(){
                    SaveForm("")
                }
            },{
                text:'�ر�',
                handler:function(){
                    myWin.close();
                }
            }]
        });
        //$('#form-save').form("clear");  
        $("#Begin").datebox('disable');
        $("#End").datebox('disable');
        
        
}
SaveFUSDForm=function(fusid,sdid)
    {
        
        var Code=$.trim($('#SDCode').val());
        if (Code=="")
        {
            var valbox = $HUI.validatebox("#SDCode", {
                required: true,
            });
            $.messager.alert('������ʾ','���벻��Ϊ��!',"error");
            return;
        }
         
        var Desc=$.trim($('#SDDesc').val());
        if (Desc=="")
        {
            var valbox = $HUI.validatebox("#SDDesc", {
                required: true,
            });
            $.messager.alert('������ʾ','���Ʋ���Ϊ��!',"error");
            return;
        }
        
        var SDType=getValueById("SDType");
        if (SDType=="")
        {
            var valbox = $HUI.combobox("#SDType", {
                required: true,
            });
            $.messager.alert('������ʾ','���Ͳ���Ϊ��!',"error");
            return;
        }
        var SDSex=getValueById("SDSex");
        if (SDSex=="")
        {
            var valbox = $HUI.combobox("#SDSex", {
                required: true,
            });
            $.messager.alert('������ʾ','�Ա���Ϊ��!',"error");
            return;
        }
        var SDUnit=getValueById("SDUnit");
        
        var SDExplain=getValueById("SDExplain");
        
        
        var iSDActive="N";
        var SDActive=$("#SDActive").checkbox('getValue');
        if(SDActive) {iSDActive="Y";}
        
        var iSDRequired="N";
        var SDRequired=$("#SDRequired").checkbox('getValue');
        if(SDRequired) {iSDRequired="Y";}
        
        var SDEffDate=$("#SDEffDate").datebox('getValue');
        var SDEffDateTo=$("#SDEffDateTo").datebox('getValue');
        
        var SDSequence=getValueById("SDSequence");
        if (SDSequence=="")
        {
            var valbox = $HUI.validatebox("#SDSequence", {
                required: true,
            });
            $.messager.alert('������ʾ','˳����Ϊ��!',"error");
            return;
        }
        
        var SDParentDR=getValueById("SDParentDR");
        var SDCascade=getValueById("SDCascade");
        var SDSelectNum=getValueById("SDSelectNum");
        
        
        
        
        var Instring=fusid+"^"+sdid+"^"+Code+"^"+Desc+"^"+SDType+"^"+SDSex+"^"+SDUnit+"^"+SDExplain+"^"+iSDActive+"^"+iSDRequired+"^"+SDEffDate+"^"+SDEffDateTo+"^"+SDSequence+"^"+SDParentDR+"^"+SDCascade+"^"+SDSelectNum;
        
        
       
        var flag=tkMakeServerCall("web.DHCCRM.CRMBaseSet","SaveFUSDetail",Instring);
        
        if(flag==0){
            $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
            $("#FUSDetailTab").datagrid('load',{
                ClassName:"web.DHCCRM.CRMBaseSet",
                QueryName:"SearchFUSDetail",
                fusrowid:fusid
                }); 
            $('#FUSDWin').dialog('close'); 
        }else{
            $.messager.alert('������ʾ',"����ʧ��","error");
        }
        
    }
SaveForm=function(id) {
    var Code=$.trim($('#Code').val());
    if (Code=="") {
        var valbox = $HUI.validatebox("#Code", {
            required: true,
        });
        $.messager.alert('������ʾ','���벻��Ϊ��!',"error");
        return;
    }
     
    var Desc=$.trim($('#Desc').val());
    if (Desc=="") {
        var valbox = $HUI.validatebox("#Desc", {
            required: true,
        });
        $.messager.alert('������ʾ','���Ʋ���Ϊ��!',"error");
        return;
    }
    
    var iActive="N";
    var Active=$("#Active").checkbox('getValue');
    if(Active) {iActive="Y";}
    
    var iLimit="N";
    var Limit=$("#Limit").checkbox('getValue');
    if(Limit) {iLimit="Y";}
    
    var Begin=$("#Begin").datebox('getValue');
    var End=$("#End").datebox('getValue');
    
    var Level = $('#Level').combobox('getValue');
    var Subject = $('#Subject').combobox('getValue');
    
    var Instring = id
                 + "^" + Code
                 + "^" + Desc
                 + "^" + iActive
                 + "^" + iLimit
                 + "^" + Begin
                 + "^" + End
                 + "^" + Level
                 + "^" + Subject;
    
    var flag = tkMakeServerCall("web.DHCCRM.CRMBaseSet","SaveFUSubject",Instring);
    
    if(flag==0){
        $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
        $("#FUSubjectTab").treegrid('load',{
            ClassName:"web.DHCCRM.CRMBaseSet",
            QueryName:"SearchFUSubject"
        }); 
        $("#FUSDetailTab").datagrid('loadData', { total: 0, rows: [] });
        $("#FUSICDTab").datagrid('loadData', { total: 0, rows: [] });
        $("#FUSLocTab").datagrid('loadData', { total: 0, rows: [] });
        $("#FUSGroupTab").datagrid('loadData', { total: 0, rows: [] });
        $('#myWin').dialog('close'); 
    }else{
        if((flag==-119)||(flag==-120)) $.messager.alert('������ʾ',"����ʧ�ܣ������Ѵ��ڣ�","error");
        else $.messager.alert('������ʾ',"����ʧ�ܣ�"+flag,"error");
    }
    
}
    
SaveFUSDSForm=function(sdid,sdsid)
    {
        
        var SDSTextVal=$.trim($('#SDSTextVal').val());
        if (SDSTextVal=="")
        {
            var valbox = $HUI.validatebox("#SDSTextVal", {
                required: true,
            });
            $.messager.alert('������ʾ','�ı�ֵ����Ϊ��!',"error");
            return;
        }
         
        var SDSUnit=$.trim($('#SDSUnit').val());
       
        
        
        var iSDSDefaultValue="N";
        var SDSDefaultValue=$("#SDSDefaultValue").checkbox('getValue');
        if(SDSDefaultValue) {iSDSDefaultValue="Y";}
        
        var iSDSDesc="N";
        var SDSDesc=$("#SDSDesc").checkbox('getValue');
        if(SDSDesc) {iSDSDesc="Y";}
        
        var SDSSequence=getValueById("SDSSequence");
        if (SDSSequence=="")
        {
            var valbox = $HUI.validatebox("#SDSSequence", {
                required: true,
            });
            $.messager.alert('������ʾ','˳����Ϊ��!',"error");
            return;
        }
        
        var LinkDetail=$("#LinkDetail").combobox("getValues");
        
        var ExclusiveDetail=$("#ExclusiveDetail").combobox("getValues");
        
        
        var Instring=sdid+"^"+sdsid+"^"+SDSTextVal+"^"+SDSUnit+"^"+iSDSDefaultValue+"^"+iSDSDesc+"^"+SDSSequence+"^"+LinkDetail+"^"+ExclusiveDetail;
        
        var flag=tkMakeServerCall("web.DHCCRM.CRMBaseSet","SaveFUSDSelect",Instring);
        
        if(flag==0){
            $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
            $("#FUSDSelectTab").datagrid('load',{
                ClassName:"web.DHCCRM.CRMBaseSet",
                QueryName:"SearchFUSDSelect",
                fusdrowid:sdid
                }); 
            
            $("#FUSDSID").val("");
            $('#SDSWin').dialog('close'); 
        }else{
            $.messager.alert('������ʾ',"����ʧ��","error");
        }
        
    }
        
function FUSDSAddData()
{
    
    var FUSDID=$("#FUSDID").val();
    if(FUSDID==""){
        $.messager.alert('������ʾ',"����ѡ���ά������������","info");
        return
    }
    
    $("#SDSWin").show();
     
        var SDSWin = $HUI.dialog("#SDSWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'����',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'����',
                id:'save_btn',
                handler:function(){
                    SaveFUSDSForm(FUSDID,"")
                }
            },{
                text:'�ر�',
                handler:function(){
                    SDSWin.close();
                }
            }]
        });
        $('#sds-save').form("clear");  
}
function FUSDSDelData()
{
    var FUSDID=$("#FUSDID").val();
    if(FUSDID==""){
        $.messager.alert('������ʾ',"����ѡ����������","info");
        return
    }
    
    var FUSDSID=$("#FUSDSID").val();
    if(FUSDSID==""){
        $.messager.alert('������ʾ',"��ѡ���ɾ��������ѡ��","info");
        return
    }
    
    var flag=tkMakeServerCall("web.DHCCRM.CRMBaseSet","DeleteFUSDSelectHISUI",FUSDSID);
    
    if(flag==0){
            $.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
            $("#FUSDSelectTab").datagrid('load',{
                ClassName:"web.DHCCRM.CRMBaseSet",
                QueryName:"SearchFUSDSelect",
                fusdrowid:FUSDID
                }); 
        }else{
            $.messager.alert('������ʾ',"ɾ��ʧ��","error");
        }
    
    
}
function FUSDSUpdateData()
{
    var FUSDID=$("#FUSDID").val();
    if(FUSDID==""){
        $.messager.alert('������ʾ',"����ѡ����������","info");
        return
    }
    
    var FUSDSID=$("#FUSDSID").val();
    if(FUSDSID==""){
        $.messager.alert('������ʾ',"��ѡ���ά��������ѡ��","info");
        return
    }
    
    
    
    if(FUSDSID!="")
    {   
    
        $("#FUSDSTemplateTab").datagrid('load', {
            ClassName:"web.DHCCRM.CRMBaseSet",
            QueryName:"SearchFUSDSTemplate",
            sdsrowid:FUSDSID
        
            });
            
          var FUSStr=tkMakeServerCall("web.DHCCRM.CRMBaseSet","GetFUSDSById",FUSDSID);
           var FUSInfo=FUSStr.split("^");
           
           
           $("#SDSTextVal").val(FUSInfo[0]);
           $("#SDSUnit").val(FUSInfo[1]);
          
           setValueById("SDSSequence",FUSInfo[3]);
           
           
           if(FUSInfo[2]=="Y")
            $("#SDSDefaultValue").checkbox('setValue',true);
           else 
            $("#SDSDefaultValue").checkbox('setValue',false);
            
           if(FUSInfo[4]=="Y")
            $("#SDSDesc").checkbox('setValue',true);
           else 
            $("#SDSDesc").checkbox('setValue',false);
           
           $("#LinkDetail").combobox("setValues",FUSInfo[5].split(","));
           $("#ExclusiveDetail").combobox("setValues",FUSInfo[6].split(","));
           
            $("#SDSWin").show();
            
            var SDSWin = $HUI.dialog("#SDSWin",{
                iconCls:'icon-w-edit',
                resizable:true,
                title:'�޸�',
                modal:true,
                buttons:[{
                    text:'����',
                    id:'save_btn',
                    handler:function(){
                        SaveFUSDSForm(FUSDID,FUSDSID)
                    }
                },{
                    text:'�ر�',
                    handler:function(){
                        SDSWin.close();
                    }
                }]
            });                  
    }
    
    
    
    
}
function StringIsNull(String) {
        if (String == null)
            return ""
        return String
    }
function FUSICDImport()
{
    
    var kill = tkMakeServerCall("web.DHCCRM.SetPlan", "KillICDDataGlobal");
        try {

            var Template = "";
            var obj = document.getElementById("File")
            if (obj) {
                obj.click();
                Template = obj.value;
                obj.outerHTML = obj.outerHTML; // ���ѡ���ļ�����
            }
            if (Template == "")
                return false;
            var extend = Template.substring(Template.lastIndexOf(".") + 1);
            if (!(extend == "xls" || extend == "xlsx")) {
                $.messager.alert('������ʾ',"��ѡ��xls�ļ�","info");
                return false;
            }

            xlApp = new ActiveXObject("Excel.Application"); // �̶�
            xlBook = xlApp.Workbooks.Add(Template); // �̶�
            xlsheet = xlBook.WorkSheets("Sheet1"); // Excel�±������

            i = 2

            while (Flag = 1) {
                IInString = ""
                StrValue = StringIsNull(xlsheet.cells(i, 1).Value);
                if (StrValue == "")
                    break;
                IInString = StrValue;

                StrValue = StringIsNull(xlsheet.cells(i, 4).Value);
                IInString = IInString + "^" + StrValue;

                var ReturnValue = tkMakeServerCall("web.DHCCRM.SetPlan",
                        "CreateICDDataGol", IInString);
                i = i + 1
            }

            xlApp.Quit();
            xlApp = null;
            xlsheet = null;

            var Return = tkMakeServerCall("web.DHCCRM.SetPlan",
                    "ImportICDDataByGol")
            
            if (Return == 0) {
                $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
                $("#FUSICDTab").datagrid('load', {
                    ClassName:"web.DHCCRM.CRMBaseSet",
                    QueryName:"SearchFUSICD",
                    fusrowid:getValueById("FUSID")
        
                });    
            }
        } catch (e) {
            $.messager.alert('������ʾ',"����ʧ��:"+e + "^" + e.message,"error");
        }
    
    
}

function FUSLocImport()
{
    var kill = tkMakeServerCall("web.DHCCRM.SetPlan", "KillLocDataGlobal");
        try {
            
            var Template = "";
            var obj = document.getElementById("File")
            if (obj) {
                obj.click();
                Template = obj.value;
                obj.outerHTML = obj.outerHTML; // ���ѡ���ļ�����
            }
            if (Template == "")
                return false;
            var extend = Template.substring(Template.lastIndexOf(".") + 1);
            if (!(extend == "xls" || extend == "xlsx")) {
                $.messager.alert('������ʾ',"��ѡ��xls�ļ�","info");
                return false;
            }
            
            xlApp = new ActiveXObject("Excel.Application"); // �̶�
            xlBook = xlApp.Workbooks.Add(Template); // �̶�
            xlsheet = xlBook.WorkSheets("Sheet1"); // Excel�±������

            i = 2

            while (Flag = 1) {
                IInString = ""
                StrValue = StringIsNull(xlsheet.cells(i, 1).Value);
                if (StrValue == "")
                    break;
                IInString = StrValue;

                StrValue = StringIsNull(xlsheet.cells(i, 4).Value);
                IInString = IInString + "^" + StrValue;

                
                var ReturnValue = tkMakeServerCall("web.DHCCRM.SetPlan",
                        "CreateLocDataGol", IInString);
                i = i + 1
            }

            xlApp.Quit();
            xlApp = null;
            xlsheet = null;

            var Return = tkMakeServerCall("web.DHCCRM.SetPlan",
                    "ImportLocDataByGol")
            if (Return == 0) {
                $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
                $("#FUSLocTab").datagrid('load', {
                    ClassName:"web.DHCCRM.CRMBaseSet",
                    QueryName:"SearchFUSLoc",
                    fusrowid:getValueById("FUSID")
        
                });    
            }
        } catch (e) {
            $.messager.alert('������ʾ',"����ʧ��:"+e + "^" + e.message,"error");
        }
    
    
    
}

function FUSICDDel()
{
    
    
    var FUSICDID=$("#FUSICDID").val();
    if(FUSICDID==""){
        $.messager.alert('������ʾ',"��ѡ���ɾ����ICD","info");
        return
    }
    
    var flag=tkMakeServerCall("web.DHCCRM.CRMBaseSet","DeleteFUSICDHISUI",FUSICDID);
    
    if(flag==0){
            $.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
            $("#FUSICDTab").datagrid('load', {
                    ClassName:"web.DHCCRM.CRMBaseSet",
                    QueryName:"SearchFUSICD",
                    fusrowid:getValueById("FUSID")
        
                });    
        }else{
            $.messager.alert('������ʾ',"ɾ��ʧ��"+flag,"error");
        }
    
    
 }
 
 function FUSLocDel()
{
    
    
    var FUSLocID=$("#FUSLocID").val();
    if(FUSLocID==""){
        $.messager.alert('������ʾ',"��ѡ���ɾ���Ŀ���","info");
        return
    }
    
    var flag=tkMakeServerCall("web.DHCCRM.CRMBaseSet","DeleteFUSLocHISUI",FUSLocID);
    
    if(flag==0){
            $.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
            $("#FUSLocTab").datagrid('load', {
                    ClassName:"web.DHCCRM.CRMBaseSet",
                    QueryName:"SearchFUSLoc",
                    fusrowid:getValueById("FUSID")
        
                });    
        }else{
            $.messager.alert('������ʾ',"ɾ��ʧ��"+flag,"error");
        }
    
    
 }