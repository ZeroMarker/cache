/*
 * FileName: dhcpe/ct/dhcpediagnosiskey.js
 * Author: yupeng
 * Date: 2021-08-04
 * Description: ����ؼ���ά��-��Ժ��
 */
var lastIndex = "";

var EditIndex = -1;

var tableName = "DHC_PE_EDKey";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
    
    
    //��ȡ�����б�
    GetLocComp(SessionStr)
           
    InitDiagnosisKeyDataGrid();
    
   //���������б�change
	$("#LocList").combobox({
 		onSelect:function(){
		 $('#DiagnosisKeyQueryTab').datagrid('load',{
            ClassName:"web.DHCPE.CT.DiagnosisKey",
            QueryName:"KeyAll",
            Desc:$("#Desc").val(),
            Color:$("#Color").val(),
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:$("#LocList").combobox('getValue')
        });       	    		 
  	 }
   });

    //��ѯ
    $("#BFind").click(function() {  
        BFind_click();      
     });
        
     //����
    $("#BAdd").click(function() {   
        BAdd_click();       
        });
        
    //�޸�
    $("#BUpdate").click(function() {    
        BUpdate_click();        
        });
     
    //����
    $("#BClear").click(function() { 
        BClear_click();     
        });
        
    //����
     $('#BSave').click(function(){
        BSave_click();
    });
       
      //���ݹ�������
    $("#BRelateLoc").click(function() { 
        BRelateLoc_click();     
        });
        
 
})


//���ݹ�������
function BRelateLoc_click()
{
    var DateID=$("#ID").val()
    if (DateID==""){
        $.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
        return false;
    }
   
   var LocID=$("#LocList").combobox('getValue')
   
  OpenLocWin(tableName,DateID,SessionStr,LocID,InitDiagnosisKeyDataGrid)

   LoadDiagnosisKey()
}

//����
function BClear_click()
{   
     $("#Color,#Desc,#ID").val("");
     $("#NoActive").checkbox('setValue',true);
     LoadDiagnosisKey();
	 BFind_click();

}

//��ѯ
function BFind_click(){
    
    $("#DiagnosisKeyQueryTab").datagrid('load',{
            ClassName:"web.DHCPE.CT.DiagnosisKey",
            QueryName:"KeyAll",
            Color:$("#Color").val(),
            Desc:$("#Desc").val(),
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:$("#LocList").combobox('getValue')
            
        }); 
}

//����
function BAdd_click()
 {
    lastIndex = $('#DiagnosisKeyQueryTab').datagrid('getRows').length - 1;
    $('#DiagnosisKeyQueryTab').datagrid('selectRow', lastIndex);
    var selected = $('#DiagnosisKeyQueryTab').datagrid('getSelected');
    if (selected) {
        if (selected.TRowID == "") {
            $.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
            return;
        }
    }
    if ((EditIndex >= 0)) {
        $.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
        return;
    }
    $('#DiagnosisKeyQueryTab').datagrid('appendRow', {
        TRowID: '',
        TDesc: '',
        TColor: '',
        TNoActive:'',
        TUpdateDate:'',
        TUpdateTime:'',
        TUserName:'',
        TEmpower:'',
        TEffPowerFlag:''
    });
    lastIndex = $('#DiagnosisKeyQueryTab').datagrid('getRows').length - 1;
    $('#DiagnosisKeyQueryTab').datagrid('selectRow', lastIndex);
    $('#DiagnosisKeyQueryTab').datagrid('beginEdit', lastIndex);
    EditIndex = lastIndex;
 }
 
 //�޸�
 function BUpdate_click()
 {
    var selected = $('#DiagnosisKeyQueryTab').datagrid('getSelected');
    if (selected==null){
            $.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
            return;
    }
    if (selected) {
        var thisIndex = $('#DiagnosisKeyQueryTab').datagrid('getRowIndex', selected);
        if ((EditIndex != -1) && (EditIndex != thisIndex)) {
            $.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
            return;
        }
        $('#DiagnosisKeyQueryTab').datagrid('beginEdit', thisIndex);
        $('#DiagnosisKeyQueryTab').datagrid('selectRow', thisIndex);
        EditIndex = thisIndex;
    
        var selected = $('#DiagnosisKeyQueryTab').datagrid('getSelected');
        
        var thisEd = $('#DiagnosisKeyQueryTab').datagrid('getEditor', {
                index: EditIndex,
                field: 'TColor'  
        });
            
        var thisEd = $('#DiagnosisKeyQueryTab').datagrid('getEditor', {
                index: EditIndex,
                field: 'TDesc'  
        });
        
        //if((selected.TEffPowerFlag!="Y")){
        //    var dd = $('#DiagnosisKeyQueryTab').datagrid('getEditor', { index: EditIndex, field: 'TEmpower' });       
        //    $(dd.target).checkbox("disable");
        //}else{
            var dd = $('#DiagnosisKeyQueryTab').datagrid('getEditor', { index: EditIndex, field: 'TEmpower' });       
            $(dd.target).checkbox("enable"); 
        //}
    }
 }

//����
function BSave_click()
{
    $('#DiagnosisKeyQueryTab').datagrid('acceptChanges');
    
    var selected = $('#DiagnosisKeyQueryTab').datagrid('getSelected');
	 if(selected ==null){
		$.messager.alert('��ʾ', "��ѡ������������", 'info');
		return;
	}
    if (selected) {
        
        if (selected.TRowID == "") {
            if ((selected.TColor == "undefined")||(selected.TDesc=="undefined")||(selected.TNoActive == "undefined")||(selected.TLevel == "")||(selected.TDesc=="")||(selected.TNoActive == "")) {
                $.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
                LoadDiagnosisKey()
                return;
            }
            $.m({
                ClassName: "web.DHCPE.CT.DiagnosisKey",
                MethodName: "Update",
                RowId:"",
                Color:selected.TColor,
                Desc:selected.TDesc,
                NoActive:selected.TNoActive,
                tableName:tableName,
                LocID:$("#LocList").combobox('getValue'),
                UserID:session['LOGON.USERID'],
                Empower:selected.TEmpower
                
            }, function (rtn) {
                var rtnArr=rtn.split("^");
                if(rtnArr[0]=="-1"){    
                    $.messager.alert('��ʾ', rtnArr[1], 'error');
                    
                }else{
                    $.messager.popover({msg:'����ɹ�',type:'success',timeout: 1000});
                }
            
                
            LoadDiagnosisKey()
            });
        } else {
			 $('#DiagnosisKeyQueryTab').datagrid('selectRow', EditIndex);
             var selected = $('#DiagnosisKeyQueryTab').datagrid('getSelected');
			 if(selected ==null){
				return;
			 }
            $.messager.confirm("ȷ��", "ȷ��Ҫ����������", function(r){
            if (r){
                   
                    if ((selected.TColor == "undefined")||(selected.TDesc=="undefined")||(selected.TNoActive == "undefined")||(selected.TColor == "")||(selected.TDesc=="")||(selected.TNoActive == "")) {
                        $.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
                        LoadDiagnosisKey()
                        return;
                    }
                    
                    $.m({
                        ClassName: "web.DHCPE.CT.DiagnosisKey",
                        MethodName: "Update",
                        RowId:selected.TRowID,
                        Color:selected.TColor,
                        Desc:selected.TDesc,
                        NoActive:selected.TNoActive,
                        UserID:session['LOGON.USERID'],
                        tableName:tableName,
                        LocID:$("#LocList").combobox('getValue'),
                        Empower:selected.TEmpower   
                
                    }, function (rtn) {
                        var rtnArr=rtn.split("^");
                        if(rtnArr[0]=="-1"){    
                        $.messager.alert('��ʾ', rtnArr[1], 'error');
                    }else{  
						 $.messager.popover({msg:'�޸ĳɹ�',type:'success',timeout: 1000});
                    }
            
                    LoadDiagnosisKey()
                });
            
            
                }
            }); 
        
            
        }
    }
}



function LoadDiagnosisKey()
{
     $("#DiagnosisKeyQueryTab").datagrid('reload');
     $("#BRelateLoc").linkbutton('disable');
}



function InitDiagnosisKeyDataGrid(){ 
    
    var DiagnosisKeyColumns = [[
            {
                field:'TRowID',
                title:'TRowID',
                hidden:true
            },{
                field:'TDesc',
                width: '200',
                title:'�ؼ���',
                editor: 'text',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',  
                    options: {
                        required: true
                    }
                }
             },{
                field:'TColor',
                width: '200',
                title:'��ɫ',
                editor: 'text',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field: 'TNoActive',
                width: '80',
                title: '����',
                align:'center',
                editor: {
                    type: 'checkbox',
                    options: {
                         on:'Y',
                        off:'N'
                    }
                        
                },
                formatter: function (value, rec, rowIndex) {
            		if(value=="Y"){
            			return '<input type="checkbox" checked="checked" disabled/>';
            		}else{
            			return '<input type="checkbox" value="" disabled/>';
            		}
            	}
            },{
                field: 'TEmpower',
                width: '80',
                title: '������Ȩ',
                align:'center',
                editor: {
                    type: 'checkbox',
                    options: {
                         on:'Y',
                        off:'N'
                    }
                        
                },
                formatter: function (value, rec, rowIndex) {
            		if(value=="Y"){
            			return '<input type="checkbox" checked="checked" disabled/>';
            		}else{
            			return '<input type="checkbox" value="" disabled/>';
            		}
            	}
                
            },{ field:'TEffPowerFlag',
            	width:100,
            	align:'center',
           	 	title:'��ǰ������Ȩ',
            	formatter: function (value, rec, rowIndex) {
            		if(value=="Y"){
            			return '<input type="checkbox" checked="checked" disabled/>';
            		}else{
            			return '<input type="checkbox" value="" disabled/>';
            		}
            	}
            }, {
                field: 'TUpdateDate',
                width: '100',
                title: '��������'
            }, {
                field: 'TUpdateTime',
                width: '100',
                title: '����ʱ��'
            }, {
                field: 'TUserName',
                width: '80',
                title: '������'
            }
            
            
            
        ]];
        
    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; } 
		
    // ��ʼ��DataGrid
    $('#DiagnosisKeyQueryTab').datagrid({
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,
        pageSize: 20,
        pageList : [20,100,200],  
        rownumbers : true,  
        singleSelect: true,
        selectOnCheck: true,
        columns: DiagnosisKeyColumns,
        queryParams:{
            ClassName:"web.DHCPE.CT.DiagnosisKey",
            QueryName:"KeyAll",
            Desc:$("#Desc").val(),
            Color:$("#Color").val(),
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:LocID
        },
        onSelect: function (rowIndex, rowData) {
            if(rowIndex!=-1){
					if((rowData.TEmpower=="Y")&&(rowData.TNoActive=="Y")){      
						$("#BRelateLoc").linkbutton('enable');
					 }else{
						$("#BRelateLoc").linkbutton('disable');
					}    
					$("#ID").val(rowData.TRowID);
				} 

        },
        onLoadSuccess: function (data) {
            EditIndex = -1;
        }
    });

        
}

