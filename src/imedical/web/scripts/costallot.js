/// 名称: web.DHCEQ.EM.BUSCostAllot
/// 描述: 折旧分摊类方法
/// 编写者：ZY
/// 编写日期: 2022-4-15
/// 产品组：设备管理

var editFlag="undefined";
var SelectRowID="";
var CARowID=getElementValue("CARowID"); 
var CATypes=getElementValue("CATypes");
var CAHold2=getElementValue("CAHold2");
var Status=getElementValue("Status");
var ReadOnly=getElementValue("ReadOnly");
var CAHold1=parseFloat(getElementValue("CAHold1"));
var Columns=getCurColumnsInfo('EM.G.CostAllot','','','')
///modified by zy0303 20220614
var ObjSources=new Array();

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
		
function initDocument()
{
	initUserInfo();
    initMessage("StoreMove"); //获取所有业务消息
    initCAAllotType();
    setElement("CAAllotType",0)
    
    //initLookUp();
	defindTitleStyle(); 
    initButton();
    initButtonWidth();
	$HUI.datagrid("#tDHCEQCostAllot",{   
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSCostAllot",
	        	QueryName:"CostAllot",
				CARowID:CARowID,
			},
			fit:true,
			border:false,	//modified zy ZY0215 2020-04-01
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			fitColumns : true,    //add by lmm 2020-06-04
			toolbar:[{
				iconCls:'icon-add',
				text:'新增',
				id:'add',
				handler:function(){insertRow();}
			},
			{
                iconCls: 'icon-cancel',
				text:'删除',
				id:'delete',
				handler:function(){DeleteData();}
			}],
			columns:Columns,
		    onClickRow: function (rowIndex, rowData) {//双击选择行编辑
		    
				if (editFlag!=rowIndex) 
				{
					if (endEditing())
					{
						$('#tDHCEQCostAllot').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
						editFlag = rowIndex;
						modifyBeforeRow = $.extend({},$('#tDHCEQCostAllot').datagrid('getRows')[editFlag]);
						bindGridEvent();  //编辑行监听响应
					} else {
						$('#tDHCEQCostAllot').datagrid('selectRow', editFlag);
					}
				}
				else
				{
					endEditing();
				}
		    
	        },
			onSelect:function(index,row){ 
				//modified by zy ZY0223 2020-04-17
				if (SelectRowID!=index)
				{
					SelectRowID=index
				}
				else
				{
					SelectRowID=""
				}
			},
			onLoadSuccess:function(){
				var rows = $('#tDHCEQCostAllot').datagrid('getRows');
			    for (var i = 0; i < rows.length; i++)
			    {
					ObjSources[i]=new SourceInfo(rows[i].CALAllotLocDR);
			    }
			}
	});
	var ReadOnly=getElementValue("ReadOnly")
	if ((ReadOnly==1)||(ReadOnly=="Y"))
	{
		$("#add").linkbutton("disable");
		$("#delete").linkbutton("disable");
		$("#BSave").linkbutton("disable");
		$("#BDelete").linkbutton("disable");
	}
}

function endEditing()
{
	if (editFlag == undefined){return true}
	if ($('#tDHCEQCostAllot').datagrid('validateRow', editFlag)){
		$('#tDHCEQCostAllot').datagrid('endEdit', editFlag);
		editFlag = undefined;
		return true;
	} else {
		return false;
	}
}

function initCAAllotType()
{
	var data=[{
				id: '0',
				text: '固定比例(%)'
			}
			/*,{
				id: '1',
				text: '工作量'
			},{
				id: '2',
				text: '科室面积(M2)'
			},{
				id: '3',
				text: '科室人数(人)'
			},{
				id: '4',
				text: '科室床位(床)'
			},{
				id: '5',
				text: '科室收入(元)'
			},{
				id: '6',
				text: '固定值'
			}*/]
	if (CATypes==2)	data=[{id: '0',text: '固定比例(%)'},{	id: '6',text: '固定值'}] 
	var CAAllotType = $HUI.combobox('#CAAllotType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:data
	});
	
}
function bindGridEvent()
{
	if (editFlag == undefined){return true}
    try
    {
        var objGrid = $("#tDHCEQCostAllot");
        var invRateEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'CALAllotPercentNum'});
        var invValueEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'CALWorkLoadNum'});
        // 数量  绑定 离开事件
        $(invRateEdt.target).bind("blur",function(){
            var CALAllotPercentNum=parseFloat($(invRateEdt.target).val());
	        var CALWorkLoadNum=CAHold1*(CALAllotPercentNum/100)
			CALWorkLoadNum=CALWorkLoadNum.toFixed(2)
	        
			var objGrid = $("#tDHCEQCostAllot"); 
			var CALWorkLoadNumEditor = objGrid.datagrid('getEditor', {index:editFlag,field:'CALWorkLoadNum'});
			$(CALWorkLoadNumEditor.target).val(CALWorkLoadNum);
			
			$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
			//$('#tDHCEQCostAllot').datagrid('beginEdit',editFlag);
        });
        $(invValueEdt.target).bind("blur",function(){
            var CALWorkLoadNum=parseFloat($(invValueEdt.target).val());
	        //var rowData = $('#tDHCEQCostAllot').datagrid('getSelected');
	        var CALAllotPercentNum=CALWorkLoadNum*100/CAHold1;
			CALAllotPercentNum=CALAllotPercentNum.toFixed(2)
			
			var objGrid = $("#tDHCEQCostAllot"); 
			var CALAllotPercentNumEditor = objGrid.datagrid('getEditor', {index:editFlag,field:'CALAllotPercentNum'});
			$(CALAllotPercentNumEditor.target).val(CALAllotPercentNum);
			
			$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
			//$('#tDHCEQCostAllot').datagrid('beginEdit',editFlag);
        });
    }
    catch(e)
    {
        alertShow(e);
    }
}
// 插入新行
function insertRow()
{
	if(editFlag>="0"){
		$("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
    var rows = $("#tDHCEQCostAllot").datagrid('getRows');
    var lastIndex=rows.length-1
    if (lastIndex==-1) lastIndex=0
    var newIndex=rows.length
	$("#tDHCEQCostAllot").datagrid('insertRow', {index:newIndex,row:{}});
	editFlag=0;
}

function DeleteData()
{
	//add by ZY0303 2659195 修复多行时不可删除第一行bug ZX0067
	var graidLength=$('#tDHCEQCostAllot').datagrid('getRows').length;
	if(graidLength<2)
	{
		messageShow("alert",'info',"提示","当前行不可删除!");
		return;
	}
	if (editFlag != undefined)
	{
		jQuery("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
		$('#tDHCEQCostAllot').datagrid('deleteRow',editFlag);
	} 
	else
	{
		messageShow("alert",'info',"提示","请选中一行!");
	}
}
function BSave_Clicked()
{
	if(editFlag>="0"){
		jQuery("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
	var data=getInputList();
	var CAAllotType=getElementValue("CAAllotType");
	data=JSON.stringify(data);
	var dataList=""
	var rows = $('#tDHCEQCostAllot').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.CALAllotLocDR=="")
		{
			alertShow("第"+(i+1)+"行科室ID不能为空!")
			return "-1"
		}
		if ((oneRow.CALAllotPercentNum=="")&&(CAAllotType!="6"))
		{
			alertShow("第"+(i+1)+"行分摊百分比不能为空!")
			return "-1"
		}
		if (oneRow.CALWorkLoadNum=="")
		{
			alertShow("第"+(i+1)+"行分摊额度不能为空!")
			return "-1"
		}
		
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 分隔符号修改
		}
	}
	if (dataList=="")
	{
		alertShow("分摊明细不能为空!");
		return;
	}
	disableElement("BSave",true)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSCostAllot","SaveData",data,dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&CARowID="+jsonData.Data+"&Status="+Status+"&ReadOnly="+ReadOnly+"&CATypes="+CATypes+"&CAHold2="+CAHold2;
		url="dhceq.em.costallot.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
	    disableElement("BSave",false)	//add by csj 2020-03-10 保存失败后启用
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	if (CARowID=="")
	{
		alertShow("没有分摊数据需要删除!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSCostAllot","SaveData",CARowID,"","1");
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		var val="&CARowID="+jsonData.Data+"&Status="+Status+"&ReadOnly="+ReadOnly+"&CATypes="+CATypes+"&CAHold2="+CAHold2;
		url="dhceq.em.costallot.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
//hisui.common.js错误纠正需要
function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}

function GetUseLoc(index,data)
{
	///modified by zy0303 20220614
	var Length=ObjSources.length
	for (var i=0;i<Length;i++)
	{
		if ((ObjSources[i].SourceID==data.TRowID)&&(editFlag!=i))
		{
			var RowNo=i+1
			alertShow("选择的科室与第"+RowNo+"行重复!")
			return;
		}
	}
	
	var rowData = $('#tDHCEQCostAllot').datagrid('getSelected');
	rowData.CALAllotLocDR=data.TRowID;
	ObjSources[index]=new SourceInfo(rowData.CALAllotLocDR);
	
	///modified by ZY02264 20210521
	var editor = $('#tDHCEQCostAllot').datagrid('getEditor',{index:editFlag,field:'CALAllotLoc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
	// modified by ZY0306 2659235  20220704
	//$('#tDHCEQCostAllot').datagrid('selectRow', editFlag).datagrid('beginEdit', editFlag);	//modified by ZY
	//$("#CLLAction"+"z"+editFlag).hide()
}

///add by zy0303 20220614
function SourceInfo(SourceID)
{
	this.SourceID=SourceID;
}
