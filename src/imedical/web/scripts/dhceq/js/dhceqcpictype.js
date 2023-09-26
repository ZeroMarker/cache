//GR0033 extjs 图片类型维护
//图片类型维护主界面布局代码
//关联csp：dhceq.process.pictype.csp
var CurrentSourceType=GetQueryString("CurrentSourceType")

$(document).ready(function () {

	self.document.title ="图片类型维护"	//jquery加载
var SelectedIndex=-1;
var preIndex=-1;

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
$('#menudatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQ.Process.DHCEQCPicType",
        QueryName:"GetPicType",
        Arg1:"",
        Arg2:$("#Desc").val(),
        Arg3:CurrentSourceType,
        ArgCnt:3
    },
    border:'true',
    height:'100%',
    //layout:'fit',
    singleSelect:true,
    toolbar:[{
                text : "新增",
                iconCls : "icon-add",
                id : 'add',
                handler : function() {
	                if(($("#Code").val()=="")||($("#Desc").val()=="")) {$.messager.alert('图片类型代码与描述不能为空！',"图片类型代码与描述不能为空！", 'warning');return}   // Modified by kdf 2018-01-24 需求号：537582
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
                		title: '提示',
               			msg: '新增成功'
            		}); 
            		Clear();  //modified by czf 550193
            		}   
            		else {
               			$.messager.alert('新增失败！',data, 'warning')
               			return;
               			}
           			}
        			})
                }
            },{
                text : "更新",
                iconCls : "icon-edit",
                id : 'update',
                handler : function() {
	                if(($("#Code").val()=="")||($("#Desc").val()=="")) {$.messager.alert('代码描述不能为空！',"代码描述不能为空！", 'warning');return}
	                var Raw=$('#menudatagrid').datagrid('getSelected');
     				if (!Raw) {$.messager.alert('请选择一行！',"请选择一行！", 'warning');return}
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
                		title: '提示',
               			msg: '更新成功'
            		}); 
            		}   
            		else {
               			$.messager.alert('更新失败！',data, 'warning')
               			return;
               			}
           			}
        			})
                }
            },{
                text : "查询",
                iconCls : "icon-search",
                id : 'search',
                handler : function() {
                    $('#menudatagrid').datagrid('load', {
        				ClassName:"web.DHCEQ.Process.DHCEQCPicType",
        				QueryName:"GetPicType",
        				Arg1:"",
        				Arg2:$("#Desc").val(),
        				Arg3:CurrentSourceType,
					Arg4:$("#Code").val(),
        				ArgCnt:4
    				});
                }
            },{                             //需求号：266171  start    add by csy 2016-10-17 
	              text:'删除',
	              iconCls: 'icon-cut', 
	              id : 'cut',      
	              handler: function(){
	                var Raw=$('#menudatagrid').datagrid('getSelected');
     				if (!Raw) {$.messager.alert('请选择一行！',"请选择一行！", 'warning');return}
     			//add by wb 2017-6-19  增加删除确认框   需求号 396228 
	                var truthBeTold = window.confirm("确定要删除该记录吗？");
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
                		title: '提示',
               			msg: '删除成功'
            	  	     });
            	  	     Clear();       //modified by czf 550178
			           		}
			          else {        //modify by mwz 2017-10-27需求号467118
			            $.messager.show({
                		title: '提示',
               			msg: '类型正被占用，删除失败'
            	  	     });
			               		return;
			                }
            		}
            			})
     				  }                   //需求号：266171  end    add by csy 2016-10-17
	      }],
            
   
    columns:[[
    	{field:'TCode',title:'图片类型代码',width:100,align:'center',editor : "validatebox"},
        {field:'TDesc',title:'图片类型描述',width:100,align:'center',editor : "validatebox"}    	       
    ]],
    
    onClickRow : function (rowIndex, rowData) {
        menudatagrid_OnClickRow();
    },
    pagination:true,
    pageSize:10,
    pageNumber:1,
    pageList:[10,20,30,40,50]   
});
	setEnabled();		// MZY0025	1318614		2020-05-13
}); 
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