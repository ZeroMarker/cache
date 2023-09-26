var preRowID=0;   
var SICSourceID=getElementValue("SICSourceID");
var SICRowID=getElementValue("SICRowID");
//�������
$(function(){
	initDocument();
	
});

function initDocument(){
	initUserInfo();
	initPanel();
	initLookUp(); //��ʼ���Ŵ�
	initButton();
	
}

//
function initPanel() {
	initTopPanel();
	initPMTemplatePanel();
	disableElement("BDelete",true);
	disableElement("BSave",true);
}

//��ʼ����ѯͷ���
function initTopPanel(){
	$("#BAdd").on("click",BAdd_Clicked);
}

//�б����
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
        	{field:'SICSourceType',title:'��Դ����',align:'center',width:95}, 
        	{field:'SICServiceItemDR',title:'SICServiceItemDR',width:50,hidden:true},   
        	{field:'SICServiceItem',title:'������Ŀ',align:'center',width:95},
        	{field:'SICUomDR',title:'SICUomDR',width:50,hidden:true},     
        	{field:'SICUom',title:'��λ',align:'center',width:60},
        	{field:'SICQuantity',title:'��������',align:'center',width:100},
        	{field:'SICModelDR',title:'SICModelDR',width:50,hidden:true},
        	{field:'SICModel',title:'����',align:'center',width:80},
        	{field:'SICServDetItemDR',title:'SICServDetItemDR',width:50,hidden:true},    
        	{field:'SICServDetItem',title:'ϸ��',align:'center',width:80},
        	{field:'SICConsumableItemDR',title:'SICConsumableItemDR',width:50,hidden:true},   
        	{field:'SICConsumableItem',title:'������Ŀ',align:'center',width:100},
        	{field:'SICQuantityType',title:'��������',align:'center',width:100},
        	{field:'SICPrice',title:'����',align:'center',width:100},
        	{field:'SICExType',title:'��չ����',align:'center',width:130},
        	{field:'SICExID',title:'��չID',align:'center',width:100},
        	
    	]],
		onClickRow:function(rowIndex,rowData){OnclickRow();},
		
	});	
}


//**************************************
//��ť����
//����
function BAdd_Clicked(){
	//if(CheckEmpty()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQCServiceConsumable","NewSaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow('alert','info','��ʾ','�����ɹ���');
		window.location.reload();     
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.SQLCODE);
		return
    }
	
}

//����
function BSave_Clicked(){
	var SICRowID=getElementValue("SICRowID"); 
	if((SICRowID=="")||(SICRowID==0)){         
		messageShow('alert','info','��ʾ','��ѡ��һ������!');         
		return true;
	}
	
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQCServiceConsumable","NewSaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		window.location.reload();
		messageShow('alert','info','��ʾ','���³ɹ���');
		
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.SQLCODE);
		return
    }
}

//ɾ��
function BDelete_Clicked()
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","","ȷ��Ҫɾ����","",confirmFun,"")
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
		messageShow('alert','info','��ʾ','ɾ���ɹ���');
		
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.SQLCODE);
		return
    }
}


//ѡ���д���
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
	       	fillData(SelectedRowID)   //ȫ�ֱ���
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

//�������
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
		messageShow('alert','info','��ʾ','��Դ�������Ͳ���Ϊ��!');
		return true;
	}
	if($('#SICServiceItem').val()==""){
		messageShow('alert','info','��ʾ','������Ŀ����Ϊ��!');
		return true;
	}
	if($('#SICConsumableItem').val()==""){
		messageShow('alert','info','��ʾ','������Ŀ����Ϊ��!');
		return true;
	}
	if($('#SICServDetItem').val()==""){
		messageShow('alert','info','��ʾ','ϸ���Ϊ��!');
		return true;
	}
	return false;
}