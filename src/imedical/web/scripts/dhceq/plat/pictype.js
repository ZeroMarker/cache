//GR0033 extjs ͼƬ����ά��
//ͼƬ����ά�������沼�ִ���
//����csp��dhceq.process.pictype.csp
var CurrentSourceType=GetQueryString("CurrentSourceType")
var SelectedIndex=-1;
var preIndex=-1;
$(document).ready(function () {
	defindTitleStyle(); 
	$HUI.datagrid('#menudatagrid',{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Process.DHCEQCPicType",
        QueryName:"GetPicType",
        RowID:"",
        Desc:getElementValue("Desc"),
        CurrentSourceType:CurrentSourceType,
    },
    fit:true,
    fitColumns:true,
    border:false,
    toolbar:[{          
                iconCls: 'icon-add',
                id : 'add',
                text:'����',          
                handler: function(){
                     SavegridData();
                }     
              },{          
                iconCls: 'icon-update',
                text:'����', 
                id : 'update',         
                handler: function(){
                     UpdategridData();
                }     
              },{          
                iconCls: 'icon-search',
                text:'��ѯ',       
                id : 'search',   
                handler: function(){
                     FindgridData();
                }     
              },{          
                iconCls: 'icon-cancel',
                text:'ɾ��',  
                id : 'cut',          
                handler: function(){
                     DeletegridData();
                }     
              },
                                  
            ] , 
    columns:[[
        {field:'TCode',title:'ͼƬ���ʹ���',width:100,align:'center'}, 
        {field:'TDesc',title:'ͼƬ��������',width:150,align:'center'}, 
    ]],
    onClickRow : function (rowIndex, rowData) {
        menudatagrid_OnClickRow();
    },    
    singleSelect: true,
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]    
});
	setEnabled();
});


function SavegridData()
{
	
	if(($("#Code").val()=="")||($("#Desc").val()=="")) {$.messager.alert('ͼƬ���ʹ�������������Ϊ�գ�',"ͼƬ���ʹ�������������Ϊ�գ�", 'warning');return}   // Modified by kdf 2018-01-24 ����ţ�537582
	var PTData="^"+$("#Code").val()+"^"+$("#Desc").val()+"^^N"
	$.ajax({
		url :"dhceq.jquery.method.csp",
		type:"POST",
		data:{
			ClassName:"web.DHCEQ.Process.DHCEQCPicType",
			MethodName:"SaveData",
			Arg1:PTData,
			ArgCnt:1
		},
	success:function (data, response, status) {
	$.messager.progress('close');
	if (data >0) {
	$('#menudatagrid').datagrid('reload');
	$.messager.show({
		title: '��ʾ',
		msg: '�����ɹ�'
	}); 
	Clear();  //modified by czf 550193
	}   
	else {
		$.messager.alert('����ʧ�ܣ�',data, 'warning')
		return;
		}
	}
	})	
		
}



function UpdategridData()
{
        if(($("#Code").val()=="")||($("#Desc").val()=="")) {$.messager.alert('������������Ϊ�գ�',"������������Ϊ�գ�", 'warning');return}
        var Raw=$('#menudatagrid').datagrid('getSelected');
		if (!Raw) {$.messager.alert('��ѡ��һ�У�',"��ѡ��һ�У�", 'warning');return}
        var PTData=Raw.TRowID+"^"+$("#Code").val()+"^"+$("#Desc").val()+"^^N"
        $.ajax({
			url :"dhceq.jquery.method.csp",
			type:"POST",
			data:{
    			ClassName:"web.DHCEQ.Process.DHCEQCPicType",
    			MethodName:"SaveData",
    			Arg1:PTData,
    			ArgCnt:1
			},
		success:function (data, response, status) {
		$.messager.progress('close');
		if (data >0) {
		$('#menudatagrid').datagrid('reload');
		$("#Code").val("")
		$("#Desc").val("")
		SelectedIndex=-1;
		preIndex=-1;
		$.messager.show({
    		title: '��ʾ',
   			msg: '���³ɹ�'
		}); 
		}   
		else {
   			$.messager.alert('����ʧ�ܣ�',data, 'warning')
   			return;
   			}
		}
		})
	
}


function FindgridData()
{
	
	$HUI.datagrid('#menudatagrid',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Process.DHCEQCPicType",
	        QueryName:"GetPicType",
	        RowID:"",
	        Desc:getElementValue("Desc"),
	        CurrentSourceType:CurrentSourceType,
	        Code:getElementValue("Code"),
	    },
	});
	
	
	
}

function DeletegridData()
{

	    var Raw=$('#menudatagrid').datagrid('getSelected');
		if (!Raw) {$.messager.alert('��ѡ��һ�У�',"��ѡ��һ�У�", 'warning');return}
	//add by wb 2017-6-19  ����ɾ��ȷ�Ͽ�   ����� 396228 
	    var truthBeTold = window.confirm("ȷ��Ҫɾ���ü�¼��");
	    if (!truthBeTold) return;
	    // end by wb
		 var PTData=Raw.TRowID
		 $.ajax({
			url :"dhceq.jquery.method.csp",
			type:"POST",
			data:{
				ClassName:"web.DHCEQ.Process.DHCEQCPicType",
				MethodName:"DeletePTData",
				Arg1:PTData,
				ArgCnt:1
			},
		error:function(XMLHttpRequest, textStatus, errorThrown){
	    messageShow("","","",XMLHttpRequest.status);
	    messageShow("","","",XMLHttpRequest.readyState);
	    messageShow("","","",textStatus);
	             },
		success:function (data, response, status) {
		$.messager.progress('close');
		if (data ==0) {
		$('#menudatagrid').datagrid('reload');	  
		$.messager.show({
			title: '��ʾ',
			msg: 'ɾ���ɹ�'
	  	     });
	  	     Clear();       //modified by czf 550178
	       		}
	      else {        //modify by mwz 2017-10-27�����467118
	        $.messager.show({
			title: '��ʾ',
			msg: '��������ռ�ã�ɾ��ʧ��'
	  	     });
	           		return;
	            }
		}
			})	
}

function menudatagrid_OnClickRow()
{
     var selected=$('#menudatagrid').datagrid('getSelected');
     if (selected)
     { 
     	SelectedIndex=$('#menudatagrid').datagrid('getRowIndex',  selected);
        if(preIndex!=SelectedIndex)
        {
             preIndex=SelectedIndex;
             $('#Code').val(selected.TCode);
             $('#Desc').val(selected.TDesc);
             setDisEnabled();		// MZY0025	1318614		2020-05-13
         }
         else
         {
	         $('#Code').val("");
             $('#Desc').val("");
             SelectedIndex = -1;
             preIndex=-1;
             $('#menudatagrid').datagrid('unselectAll')
             setEnabled();		// MZY0025	1318614		2020-05-13
         }
     }
}


function Clear(){      //modified by czf 550193
    $('#Code').val("");
    $('#Desc').val("");
}
// MZY0025	1318614		2020-05-13
function setEnabled()
{
	disableElement("add",false);
	disableElement("update",true);
	//disableElement("search",true);
	disableElement("cut",true);
}
function setDisEnabled()
{
	disableElement("add",true);
	disableElement("update",false);
	//disableElement("search",true);
	disableElement("cut",false);
}