var preRowID=0;   
var SICSourceID=getElementValue("SICSourceID");
var SICRowID=getElementValue("SICRowID");
//界面入口
$(function(){
	initDocument();
	
});

function initDocument(){
	initUserInfo();
	initPanel();
	initLookUp(); //初始化放大镜
	initButton();
	
}

//
function initPanel() {
	initTopPanel();
	initPMTemplatePanel();
	disableElement("BDelete",true);
	disableElement("BSave",true);
}

//初始化查询头面板
function initTopPanel(){
	$("#BAdd").on("click",BAdd_Clicked);
}

//列表面板
function initPMTemplatePanel(){ 
	$HUI.datagrid("#tDHCEQConsumableItem",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQCServiceConsumable",
	        QueryName:"GetService",	        
	        SourceID:SICSourceID,
		},
	    fie:true,
	    singleSelect:true,
		fitColumns:true,
		pagination:true,
    	columns:[[
    		{field:'SICRowID',title:'SICRowID',width:50,hidden:true},    
        	{field:'SICSourceType',title:'来源类型',align:'center',width:95}, 
        	{field:'SICServiceItemDR',title:'SICServiceItemDR',width:50,hidden:true},   
        	{field:'SICServiceItem',title:'服务项目',align:'center',width:95},
        	{field:'SICUomDR',title:'SICUomDR',width:50,hidden:true},     
        	{field:'SICUom',title:'单位',align:'center',width:60},
        	{field:'SICQuantity',title:'消耗数量',align:'center',width:100},
        	{field:'SICModelDR',title:'SICModelDR',width:50,hidden:true},
        	{field:'SICModel',title:'机型',align:'center',width:80},
        	{field:'SICServDetItemDR',title:'SICServDetItemDR',width:50,hidden:true},    
        	{field:'SICServDetItem',title:'细项',align:'center',width:80},
        	{field:'SICConsumableItemDR',title:'SICConsumableItemDR',width:50,hidden:true},   
        	{field:'SICConsumableItem',title:'消耗项目',align:'center',width:100},
        	{field:'SICQuantityType',title:'数量类型',align:'center',width:100},
        	{field:'SICPrice',title:'单价',align:'center',width:100},
        	{field:'SICExType',title:'扩展类型',align:'center',width:130},
        	{field:'SICExID',title:'扩展ID',align:'center',width:100},
        	
    	]],
		onClickRow:function(rowIndex,rowData){OnclickRow();},
		
	});	
}


//**************************************
//按钮函数
//新增
function BAdd_Clicked(){
	//if(CheckEmpty()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQCServiceConsumable","NewSaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow('alert','info','提示','操作成功！');
		window.location.reload();     
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.SQLCODE);
		return
    }
	
}

//更新
function BSave_Clicked(){
	var SICRowID=getElementValue("SICRowID"); 
	if((SICRowID=="")||(SICRowID==0)){         
		messageShow('alert','info','提示','请选择一条数据!');         
		return true;
	}
	
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQCServiceConsumable","NewSaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		window.location.reload();
		messageShow('alert','info','提示','更新成功！');
		
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.SQLCODE);
		return
    }
}

//删除
function BDelete_Clicked()
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","","确定要删除吗？","",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQCServiceConsumable","NewSaveData",data,"1");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		window.location.reload();
		messageShow('alert','info','提示','删除成功！');
		
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.SQLCODE);
		return
    }
}


//选中行处理
function OnclickRow(){
    var selected=$('#tDHCEQConsumableItem').datagrid('getSelected');
    if (selected)
    {  
       var SelectedRowID=selected.SICRowID;
       var SICRowID=SelectedRowID
       if(preRowID!=SelectedRowID)
       {
	       	disableElement("BAdd",true);
	        disableElement("BSave",false);
	       	disableElement("BDelete",false);
	       	fillData(SelectedRowID)   //全局变量
            preRowID=SelectedRowID;
            
       }
       else
       {
	       	disableElement("BAdd",false);
	       	disableElement("BSave",true);
	        disableElement("BDelete",true);
	       	SICRowID=0;
			Clear();        		
            SelectedRowID =-1;
            preRowID=0;
            $('#tDHCEQConsumableItem').datagrid('unselectAll');
       }
   }	
}
function fillData(RowID)
{
	if (RowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQCServiceConsumable","GetServiceTypeID",RowID)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
}

//清空数据
function Clear()
{
	$('#SICRowID').val('');
	$('#SICSourceType').combobox('setValue','');
	$('#SICServiceItem').val('');
	$('#SICServiceItemDR').val('');
	$('#SICUom').val('');
	$('#SICUomDR').val('');
	$('#SICQuantity').val('');
	$('#SICModel').val('');
	$('#SICModelDR').val('');
	$('#SICServDetItem').val('');
	$('#SICServDetItemDR').val('');
	$('#SICConsumableItem').val('');
	$('#SICConsumableItemDR').val('');
	$('#SICQuantityType').combobox('setValue','');
	
}


function setSelectValue(vElementID,rowData)
{
	if(vElementID=="SICServiceItem") {setElement("SICServiceItemDR",rowData.TRowID)}
	else if(vElementID=="SICUom") {setElement("SICUomDR",rowData.TRowID)}
	else if(vElementID=="SICServDetItem") {setElement("SICServDetItemDR",rowData.TRowID)}
	else if(vElementID=="SICConsumableItem") {setElement("SICConsumableItemDR",rowData.TRowID)}
	else if(vElementID=="SICModel") {setElement("SICModelDR",rowData.TRowID)}
}

function CheckEmpty(){
	if($('#SICSourceType').combobox('getValue')==0){
		messageShow('alert','info','提示','来源类型类型不能为空!');
		return true;
	}
	if($('#SICServiceItem').val()==""){
		messageShow('alert','info','提示','服务项目不能为空!');
		return true;
	}
	if($('#SICConsumableItem').val()==""){
		messageShow('alert','info','提示','消耗项目不能为空!');
		return true;
	}
	if($('#SICServDetItem').val()==""){
		messageShow('alert','info','提示','细项不能为空!');
		return true;
	}
	return false;
}