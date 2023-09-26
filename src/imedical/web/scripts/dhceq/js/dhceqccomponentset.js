
var editFlag="undefined";	//判断当前编辑行
var PreSelectedRowID = "";	//取当前选中的组件设备记录ID

var GlobalObj = {
	
	ComponentDR : "",
	SysSetFlag : "" , //DHC_EQCComponent Hold1 字段存是否是系统设置
	ComponentSetColumns : GetCurColumnsInfo('DHCEQCComponentSet',"","",""),
	ComponentSetItemColumns :GetCurColumnsInfo('DHCEQCComponentSetItem',"","",""),
	ClearData : function(vElementID)
	{
		if (vElementID=="Component") {this.ComponentDR = "";}
	},
	ClearAll : function()
	{
		this.ComponentDR = "";
		this.SysSetFlag = "";
	}
}

$(document).ready(function (){
	initDocument();	
	$('#ComponentSet').datagrid({  
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQCComponentSet",
	        QueryName:"GetComponentSet",
	        Arg1:$("#SourceType").combobox("getValue"),
	        Arg2:$("#SourceID").combogrid("getValue"),
	        Arg3:GlobalObj.ComponentDR,
	        ArgCnt:3
	    },
	    border:'true',
	    fit:true,
		rownumbers: true,  //如果为true，则显示一个行号列。
	    singleSelect:true,
	    columns:GlobalObj.ComponentSetColumns,
	    /*
	    columns:[[
	    	{field:'TComponentID',title:'ComponentID',width:50,hidden:true},
	        {field:'TSourceType',title:'SourceType',width:60,hidden:true}, 
	        {field:'TSourceTypeDesc',title:'来源类型',width:60,align:'center'},
	        {field:'TSourceID',title:'SourceID',width:100,align:'center',hidden:true},  
	        {field:'TSource',title:'来源',width:100,align:'center'},  //,hidden:true
	        {field:'TComponentName',title:'组件名',width:100,align:'center'},
	        {field:'TComponentDesc',title:'组件描述',width:100,align:'center'},
	        //{field:'TLayout',title:'布局',width:100,align:'center'},
	    ]],
	    */
	    onClickRow : function (rowIndex, rowData) {
	        fillData_OnClickRow(rowIndex, rowData);
	    },
	    pagination:true,
	    pageSize:12,
	    pageNumber:1,
	    pageList:[12,24,36] 
	});
	$("#SourceType").combobox({
		onChange: function(SourceType,TSourceType){
			if($("#SourceType").combobox("getValue")==0)
			{
				$("#SourceID").combogrid({
					disabled:true
				})
	    		$('#SourceID').combogrid('setValue','0')
				//$("#SourceID").combogrid("getValue")==0
			}

			else if($("#SourceType").combobox("getValue")==1)
			{
				$("#SourceID").combogrid({
					disabled:false,
					idField:'Hidden',
					textField:'Desc',
					url:'dhceq.jquery.csp',
					queryParams:{
						ClassName:'web.DHCEQFind',
						QueryName:'GetHospital',
						Arg1:'',
						ArgCnt:1
						},
					columns:[[
						{field:'Desc',title:'类型',width:130,align:'center'},
					]]
				});	
	
			}
			else if($("#SourceType").combobox("getValue")==2)
			{
				$("#SourceID").combogrid({
					disabled:false,
					idField:'GroupID',
					textField:'GroupName',
					url:'dhceq.jquery.csp',
					queryParams:{
						ClassName:'web.DHCEQFind',
						QueryName:'Group',
						Arg1:'',
						ArgCnt:1
						},
					columns:[[
						{field:'GroupName',title:'类型',width:130,align:'center'},
					]]
				});	
	
			}
			else if($("#SourceType").combobox("getValue")==3)
			{
				$("#SourceID").combogrid({
					disabled:false,
					idField:'Hidden',
					textField:'UserName',
					url:'dhceq.jquery.csp',
					queryParams:{
						ClassName:'web.DHCEQFind',
						QueryName:'User',
						Arg1:'',
						ArgCnt:1
						},
					columns:[[
						{field:'UserName',title:'类型',width:130,align:'center'},
					]]
				});	
	
			}
		}
	});
});

function initDocument()
{
	GlobalObj.ClearAll();
	initComponentPanel()
	initComponentData()
	jQuery("#BAddComponent").click(function(){AddComponent()});
	jQuery("#BFind").click(function(){findGridData()});
	jQuery("#BSvae").click(function(){SavegridData()});
	jQuery("#BDelete").click(function(){DeleteGridData()});
}
function AddComponent()
{
	var url="dhceq.code.component.csp?&ComponentID="+GlobalObj.ComponentDR;
	OpenNewWindow(url);
}
function LoadData(vElementID)
{
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");
	if (vElementID=="Component") {initComponentData();}
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="Component") {GlobalObj.ComponentDR = CurValue;}
}
//GAI
function fillData_OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TRowID)
	{
		setJQValue($('#ComponentDR'),rowData.TComponentID);
		GlobalObj.ComponentDR=rowData.TComponentID
		GlobalObj.SysSetFlag=rowData.THold1
		setJQValue($('#Component'),rowData.TComponentName);
		setJQValue($('#Layout'),rowData.TLayout);
		setJQValue($('#SourceType'),rowData.TSourceType);
		setJQValue($('#SourceID'),rowData.TSourceID,"value");
		setJQValue($('#Source'),rowData.TSource,"text");
		setJQValue($('#ComponentDesc'),rowData.TComponentDesc);
		PreSelectedRowID=rowData.TRowID
		if (GlobalObj.SysSetFlag=="Y")
		{
			jQuery('#BSvae').hide();
			jQuery('#BDelete').hide();
		}
		else
		{
			$('#BSvae').show();
			$('#BDelete').show();
		}
	}
	else
	{
		Clear();
		if (GlobalObj.SysSetFlag=="Y")
		{
			$('#BSvae').show();
			$('#BDelete').show();
		}
		PreSelectedRowID=""
	}
	$('#ComponentSetItem').datagrid({   
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQCComponentSet",
	        QueryName:"GetComponentSetItem",
	        Arg1:PreSelectedRowID,
	        ArgCnt:1
	    },
	    border:'true',
	    fit:true,
		rownumbers: true,  //如果为true，则显示一个行号列。
	    singleSelect:false,
	    toolbar:[{         
	                iconCls: 'icon-save',
	                text:'保存',          
	                handler: function(){SaveItemgridData();}
	             }
	    ],
	    columns:GlobalObj.ComponentSetItemColumns,
	    /*
	    columns:[[
	    	{field:'TRowID',title:'ID',width:50,hidden:true},
	    	{field:'TCSIRowID',title:'ID',width:50,hidden:true},
	        {field:'TName',title:'名称',width:100,align:'center'},
	        {field:'TCaption',title:'描述',width:100,align:'center',editor:texteditor},
	        {field:'TStyle',title:'样式',width:100,align:'center',editor:texteditor},
	        {field:'TSort',title:'排序',width:100,align:'center',editor:texteditor},
	        {field:'THidden',title:'隐藏',width:100,align:'center',formatter:checkboxPanel},
	        {field:'TNeedFlag',title:'是否需要',width:100,align:'center',formatter:checkboxPanel},
	    ]],
	    */
	    onSelect: function (rowIndex, rowData) {//单击行取消编辑
	    	if (editFlag!="undefined") 
	    	{
                jQuery("#ComponentSetItem").datagrid('endEdit', editFlag); 
            }
        },
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    	if (editFlag!="undefined")
	    	{
                jQuery("#ComponentSetItem").datagrid('endEdit', editFlag); 
            }
            
            jQuery("#ComponentSetItem").datagrid('beginEdit', rowIndex);
            editFlag =rowIndex;
        },
	    pagination:true,
	    pageSize:12,
	    pageNumber:1,
	    pageList:[12,24,36]  
	});
}

function SavegridData(){
	if (CheckData()==false) return false;
	var val=""
	val=PreSelectedRowID;
	val=val+"^"+getJQValue($('#SourceType'),'value');
	val=val+"^"+getJQValue($('#SourceID'),'value');
	val=val+"^"+GlobalObj.ComponentDR;
	val=val+"^";	//Layout
	val=val+"^";	//Hold1
	val=val+"^";	//Hold2
	val=val+"^";	//Hold3
	val=val+"^";	//Hold4
	val=val+"^";	//Hold5
	$.ajax({
    	//async: false,
		url :"dhceq.jquery.method.csp",
		type:"POST",
        data:{
	        ClassName:"web.DHCEQCComponentSet",
	        MethodName:"SaveComponentSetNew",
                Arg1:val,
                Arg2:'0',
                ArgCnt:2
	    },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                messageShow("","","",XMLHttpRequest.status);
                messageShow("","","",XMLHttpRequest.readyState);
                messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
    		if (data ==0) 
    		{
				$.messager.show({title: '提示',msg: '保存成功'});
				$('#ComponentSet').datagrid('reload');
				Clear();
       		}
        	else
        	{
           		$.messager.alert('添加失败！',data, 'warning')
           		return;
            }
        }
	})
}

function DeleteGridData(){
    if (PreSelectedRowID==""){
            $.messager.alert("错误", "请选中一行！", 'error') /// Modfied by zc 2015-07-27 ZC0026
            return false;
    }else
    {
	    $.messager.confirm('请确认', '您确定要删除所选的行？', function (b) {
	        if (b==false)
	        {
	             return;
	        }
	        else
	        {
				$.ajax({
			    	//async: false,
					url :"dhceq.jquery.method.csp",
					type:"POST",
			        data:{
				        ClassName:"web.DHCEQCComponentSet",
				        MethodName:"SaveComponentSetNew",
		                Arg1:PreSelectedRowID,
		                Arg2:'1',
		                ArgCnt:2
				    },
			       	error:function(XMLHttpRequest, textStatus, errorThrown){
		                    messageShow("","","",XMLHttpRequest.status);
		                    messageShow("","","",XMLHttpRequest.readyState);
		                    messageShow("","","",textStatus);
			        },
		            success:function (data, response, status) {
        				$.messager.progress('close');
	            		if (data ==0) 
	            		{
							$.messager.show({title: '提示',msg: '删除成功!'});
							$('#ComponentSetItem').datagrid({   
							    url:'dhceq.jquery.csp', 
							    queryParams:{
							        ClassName:"web.DHCEQCComponentSet",
							        QueryName:"GetComponentSetItem",
							        Arg1:0,
							        ArgCnt:1
							    }
							})
							$('#ComponentSet').datagrid('reload');
		           		}
		            	else
		            	{
		               		$.messager.alert('删除失败！',data, 'warning')
		               		return;
		                }
		            }
		    	})
	        }         
        })
		    
	}
}
function findGridData()
{
	$('#ComponentSet').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
	        ClassName:"web.DHCEQCComponentSet",
	        QueryName:"GetComponentSet",
	        Arg1:getJQValue($("#SourceType"),'value'),
			Arg2:getJQValue($("#SourceID"),'value'),
	        Arg3:GlobalObj.ComponentDR,
	        ArgCnt:3
		}
	    });
}
function SaveItemgridData()
{
	var ListData=""
	if(editFlag>="0"){
		jQuery("#ComponentSetItem").datagrid('endEdit', editFlag);
	}
	var rows = jQuery("#ComponentSetItem").datagrid('getRows');
	if(rows.length<=0){
		return ListData;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].TCSIRowID=="")&&(rows[i].TNeedFlag=='N')){
			//messageShow("","","",rows[i].TNeedFlag+"&&"+rows[i].TCSIRowID)
			}
		else
		{
			var tmp=""
			tmp=rows[i].TNeedFlag
			tmp=tmp+"^"+rows[i].TCSIRowID
			tmp=tmp+"^"+rows[i].TRowID
			tmp=tmp+"^"+rows[i].TCaption
			tmp=tmp+"^"+rows[i].TCaptionStyle
			tmp=tmp+"^"+rows[i].TDisabled
			tmp=tmp+"^"+rows[i].TDisplayOnly
			tmp=tmp+"^"+rows[i].THidden
			tmp=tmp+"^"+rows[i].TStyle
			tmp=tmp+"^"+rows[i].TReadOnly
			tmp=tmp+"^"+rows[i].TSort
			tmp=tmp+"^"	//+rows[i].THold1
			tmp=tmp+"^"	//+rows[i].THold2
			tmp=tmp+"^"	//+rows[i].THold3
			tmp=tmp+"^"	//+rows[i].THold4
			tmp=tmp+"^"	//+rows[i].THold5
			dataList.push(tmp);
		}
	}
	var ListData=dataList.join("&");
	
	$.ajax({
    	//async: false,
		url :"dhceq.jquery.method.csp",
		type:"POST",
        data:{
            ClassName:"web.DHCEQCComponentSet",
            MethodName:"SaveComponentItem",
                Arg1:PreSelectedRowID,
                Arg2:ListData,
                ArgCnt:2
	    },
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                messageShow("","","",XMLHttpRequest.status);
                messageShow("","","",XMLHttpRequest.readyState);
                messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
				$.messager.progress('close');
        		if (data ==0) 
        		{
					$.messager.show({title: '提示',msg: '保存成功'});
					$('#ComponentSetItem').datagrid('reload');
           		}
            	else
            	{
               		$.messager.alert('添加失败！',data, 'warning')
               		return;
                }
        }
	})
}

//数据有效检测 Add JDL 20151020
function CheckData()
{
    if ($('#SourceType').combobox('getValue')==""){
            $.messager.alert("错误", "来源类型为空！", 'error')
            return false;
    }
    //$('#SourceID').val('setValue','0')
    if ($('#SourceID').combogrid('getValue')==""){
            $.messager.alert("错误", "来源为空！", 'error')
            return false;
    }
    if (GlobalObj.ComponentDR==""){
            $.messager.alert("错误", "组件为空！", 'error')
            return false;
    }
	return true;
}
function Clear()
{
	setJQValue($('#SourceType'),"")
	setJQValue($('#SourceID'),"","value")
	setJQValue($('#SourceID'),"","text")
	setJQValue($('#Source'),"")
	GlobalObj.ComponentDR=""
	GlobalObj.SysSetFlag=""
	setJQValue($('#Component'),"")
}

function checkboxDisabledChange(TDisabled,rowIndex)
{
	var row = jQuery('#ComponentSetItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TDisabled==key)
			{
				if (((val=="N")||val=="")) row.TDisabled="Y"
				else row.TDisabled="N"
			}
		})
	}
}


function checkboxDisplayOnlyChange(TDisplayOnly,rowIndex)
{
	var row = jQuery('#ComponentSetItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TDisplayOnly==key)
			{
				if (((val=="N")||val=="")) row.TDisplayOnly="Y"
				else row.TDisplayOnly="N"
			}
		})
	}
}

function checkboxHiddenChange(THidden,rowIndex)
{
	var row = jQuery('#ComponentSetItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (THidden==key)
			{
				if (((THidden=="N")||val=="")) row.THidden="Y"
				else row.THidden="N"
			}
		})
	}
}

function checkboxReadOnlyChange(TReadOnly,rowIndex)
{
	var row = jQuery('#ComponentSetItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TReadOnly==key)
			{
				if (((val=="N")||val=="")) row.TReadOnly="Y"
				else row.TReadOnly="N"
			}
		})
	}
}

function checkboxNeedFlagChange(TNeedFlag,rowIndex)
{
	var row = jQuery('#ComponentSetItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TNeedFlag==key)
			{
				if (val=="N") row.TNeedFlag="Y"
				else row.TNeedFlag="N"
			}
		})
	}
}
