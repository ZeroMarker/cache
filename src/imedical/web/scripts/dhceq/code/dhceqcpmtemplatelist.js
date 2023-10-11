/***************************
//�ļ�����        dhceqcpmtemplatelist.js
//�ļ���������:   PMģ����ϸά��
//������:         H_Haiman   HHM0032
//����ʱ��:       2016-01-13
//����:           
//�޸���:         
//�޸�ʱ�䣻      
//�޸�����:    
//***************************/

//ȫ�ֱ���
/************************************/
var SelectedRowID = 0;
var preRowID=0;  
var RowID=0   //ȫ�ֱ��� ���ڴ���ѡ����
//����DRȡֵ��ѡ����
var ElementObj={
	RID:"",
	Note:"",
	DefaultVal:"",
	Sort:"",
	TemplateDR:initPageID()[0].split("=")[1],	//modified by csj 2020-02-24 ����ţ�1191838 ����
	TType:initPageID()[1].split("=")[1],	//modified by csj 2020-02-24 ����ţ�1191838 ����
	TName:"",//initPageName(),
	TCaption:"",
	
	MaintItemDR:"",
	MItem:"",
	
	MaintItemCatDR:"",
	MItemCat:"",
	
	ClearData:function(){
		this.RID="";
		//this.TemplateDR="";
		//this.TType="";
		//this.TName="";
		//this.TCaption="";
		//this.MaintItemDR="";
		//this.MItem="";
		//this.MaintItemCatDR="";
		//this.MItemCat="";
		this.Note="";
		this.DefaultVal="";
		this.Sort="";
	}
}
//*************************************

//�������
jQuery(document).ready(function(){
	setTimeout("initDocument();", 50);
});
function initDocument(){
	//add by lmm 2020-04-27 1289831
	setRequiredElements("MaintItem^Sort")	
	initMessage();	
	initPanel();
	initPMTemplateListData();	
	//modify by lmm 2020-04-03
	defindTitleStyle();}

//
function initPanel() {
	initTopPanel();
	initPMTemplateListPanel();
	//modify by lmm 2020-04-27
	//initMaintItemPanel();   
	initLookUp();
}
//��ʼ����ѯͷ���
function initTopPanel(){
	jQuery("#BAdd").linkbutton({
		 iconCls: 'icon-w-add'
	});
	jQuery("#BUpdate").linkbutton({
		iconCls: 'icon-w-save'
	});
	jQuery("#BDel").linkbutton({
		iconCls: 'icon-w-close'
	});
	jQuery("#BAdd").on("click",BAddClick);
	jQuery("#BUpdate").on("click", BUpdateClick);
	jQuery("#BDel").on("click",BDelClick);	
}

//modified by csj 2020-02-24 ���ز�ѯ��������
function initPageID(){
	var str=window.location.search.substr(1);
	var tmp=str.split('&');	
	return tmp;
}
//*************************************
// MZY0076	2021-05-25
//�б����
function initPMTemplateListPanel(){
	jQuery('#tPMTemplateList').datagrid({
		columns:[[
			{field:'TRowID',title:'RowID',width:50,hidden:true},
			{field:'TName',title:'ģ������',align:'center',width:100},
			{field:'TCaption',title:'ģ�����',align:'center',width:100,hidden:true},
			{field:'TType',title:'����',align:'center',width:80},
			{field:'TItemCat',title:'��Ŀ����',align:'center',width:100}, 
			{field:'TItemCode',title:'��Ŀ����'},
			{field:'TItem',title:'��Ŀ'},
			{field:'TNote',title:'��ϸע��',align:'center',width:100},
			{field:'TDefaultVal',title:'��ϸĬ��ֵ',align:'center',width:100},
			{field:'TSort',title:'����',align:'center',width:100},
		]],
    	fitColumns: true,
    	singleSelect:true,
    	loadMsg:'���ݼ����С���',
    	pagination:true,
		pageSize:20,
		pageNumber:1,
		pageList:[20,40,60,80,100], 
    	rownumbers: true,  //���Ϊtrue������ʾһ���к���
		onBeforeLoad: function(param) {
			//Ŀ����Ϊ�˷�ֹloadDataʱ������url��������
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadSuccess:function(data){},
		onLoadError: function() {
			jQuery.messager.alert("����", "�����б����.");
		},
		onSelect:onSelectRow
	});
}

//������Ŀ�����б�
function initMaintItemPanel(){
	jQuery('#MaintItem').combogrid({
		panelWidth:500,
    	singleSelect:true,
    	loadMsg:'���ݼ����С���',
    	pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50], 
    	rownumbers: true,  //���Ϊtrue������ʾһ���к���
    	idField:'TRowID',
		textField:'TMIDesc',
		columns:[[
				{field:'TRowID',title:'ID',align:'center',width:30,hidden:true},
				{field:'TMICode',title:'����',align:'center',width:60},
		        {field:'TMIDesc',title:'��Ŀ',align:'center',width:100},		    
		       	{field:'TMICaption',title:'����',align:'center',width:100},
		        {field:'TMICDesc',title:'��Ŀ����',align:'center',width:100},
		]],
		onLoadSuccess:function(data){},
		onLoadError:function() {jQuery.messager.alert("����", "������Ŀ�б�ʧ��!");},
		onChange: function(newValue, oldValue){},
		onSelect: function(rowIndex, rowData) {ElementObj.MaintItemDR=rowData.TRowID},//��ȡ�����б��RowID
		keyHandler:{
			query:function(){},
			enter:function(){ComboGridKeyEnter(vElementID);},
		 	up:function(){ComboGridKeyUp(vElementID);},
			down:function(){ComboGridKeyDown(vElementID);},
			left:function(){},
			right:function(){}
		}
	});	
	jQuery('#TDMaintItem').focusin(function(){initMaintItemData()});
}


//*************************************
//�����������
function initPMTemplateListData(){
	var queryParams = new Object();
	var ClassName = "web.DHCEQ.Code.DHCEQCPMTemplateList";
	var QueryName = "PMTemplateList";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 =ElementObj.TemplateDR; 
	queryParams.ArgCnt =1;	
	loadDataGridStore("tPMTemplateList", queryParams);
}

//������Ŀ�����б�����
function initMaintItemData(){
	var queryParams = new Object();
	var ClassName = "web.DHCEQ.Code.DHCEQCPMTemplateList";
	var QueryName = "GetMaintItem";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 =ElementObj.TType;	//modified by csj 2020-02-24 ����ţ�1191838
	queryParams.ArgCnt =1;
	loadComboGridStore("MaintItem", queryParams);	
}

//**************************************
//��ť����
//����
function BAddClick(){
	if (checkMustItemNull()) return;	//add by lmm 2020-04-27 1289831
	var data=""
	var Note=jQuery('#Note').val();
	var Sort=jQuery('#Sort').val();
	var DefaultVal=jQuery('#DefaultVal').val();
	data=""+"^"+ElementObj.TemplateDR+"^"+ElementObj.MaintItemDR+"^"+Note+"^"+Sort+"^"+DefaultVal
	resultData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplateList','SaveData',data,'2');
	//messageShow("","","",resultData)
	if(resultData<0){
		if(resultData==-3001){
			alertShow('�����������ظ���');
			return;
		}
		alertShow('����ʧ�ܣ�')
	}
	else{
		jQuery('#tPMTemplateList').datagrid("reload");
		Clear();
	}
}

//
function BUpdateClick(){
	//begin add by jyp 2018-03-12 544700
	if((RowID=="")||(RowID==0)){         
		alertShow('��ѡ��һ������!');         
		return true;
	}
	//End add by jyp 2018-03-12 544700
	if (checkMustItemNull()) return;	//add by lmm 2020-04-27 1289831
	var data=""
	var Note=jQuery('#Note').val();
	var Sort=jQuery('#Sort').val();
	var DefaultVal=jQuery('#DefaultVal').val();
	data=ElementObj.RID+"^"+ElementObj.TemplateDR+"^"+ElementObj.MaintItemDR+"^"+Note+"^"+Sort+"^"+DefaultVal
	resultData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplateList','SaveData',data,'2');
	//messageShow("","","",resultData)
	if(resultData<0){
		if(resultData==-3001){
			alertShow('�����������ظ���');
			return;
		}		
		alertShow('����ʧ�ܣ�');
	}
	else{
		jQuery('#tPMTemplateList').datagrid("reload");
		Clear();
	}
}

//
function BDelClick(){
	//add by lmm 2020-04-27 1289852
     var selected=jQuery('#tPMTemplateList').datagrid('getSelected');
     if (!selected)
     {
	     alertShow('δѡ�����ݣ�')
	     return;
	    }
	//add by lmm 2020-04-27 1289852
	var truthBeTold = window.confirm("ȷ��Ҫɾ����");//279878  Add By BRB 2016-11-14 ���ӵ��ɾ��������ʾ��
    if (!truthBeTold) return;//279878  Add By BRB 2016-11-14  ���ӵ��ɾ��������ʾ�� 
	if(RowID!=0){
		var returnData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplateList','SaveData',RowID,'1')	
		if(returnData<0){
			alertShow('ɾ��ʧ�ܣ�')
		}
		else{
				jQuery('#tPMTemplateList').datagrid("reload");
				Clear();
			}
	}
	else{
		alertShow('��ѡ��һ�н��в�����');
	}
}
function Clear(){
	jQuery('#TType').combogrid('setValue','');
	jQuery('#Note').val('');
	jQuery('#Sort').val('');
	jQuery('#DefaultVal').val('');
	jQuery('#MaintItem').combogrid('setValue',''); //add by lmm 2018-03-13 553376
}
function CheckEmpty(){
	if(jQuery('#MaintItem').combogrid('getValue')==0){
		alertShow('��Ŀ����Ϊ��!');
		return true;
	}
	if(jQuery('#Sort').val()==""){
		alertShow('������Ϊ��!')
		return true;
	}
	return false;
}
//**************************************
//�������¼�����



//
//ѡ���д���
//modify by lmm 2020-04-27
function onSelectRow(rowIndex, rowData){
     var selected=jQuery('#tPMTemplateList').datagrid('getSelected');
     if (selected)
     {  
        var SelectedRowID=selected.TRowID;
        if(preRowID!=SelectedRowID)
        {
	        RowID=selected.TRowID ;   //ȫ�ֱ���
	        var Obj=fillData(selected.TRowID);

			setElement("MaintItem",Obj.MItem)			
			setElement("Note",Obj.Note)			
			setElement("DefaultVal",Obj.DefaultVal)			
			setElement("Sort",Obj.Sort)
			
            preRowID=SelectedRowID;
         }
         else
         {
	       	RowID=0;
	       	ElementObj.ClearData();
			setElement("MaintItem","")			
			setElement("Note","")			
			setElement("DefaultVal","")			
			setElement("Sort","")							        		
            SelectedRowID = 0;
            preRowID=0;
            jQuery('#tPMTemplateList').datagrid('unselectAll');	// MZY0096	2134929		2021-09-16
         }
     }	
}
//**************************************
//��ȡҳ�����ݺ���
function GetPageValue(type){
	var MaintItem=jQuery('#MaintItem').combogrid('getValue');
	var Note=jQuery('#Note').val();
	var DefaultVal=jQuery('#DefaultVal').val();
	var Sort=jQuery('#Sort').val();
}
function fillData(rowid){
	if(rowid==""){return;}
	var resultData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplateList','GetPMTemplateListByID',rowid);
	data=resultData.split('^');
	ElementObj.RID=data[0];
	ElementObj.Note=data[1];
	ElementObj.DefaultVal=data[2];
	ElementObj.Sort=data[3];
	ElementObj.TemplateDR=data[4];
	ElementObj.TType=data[5];
	ElementObj.TName=data[6];
	ElementObj.TCaption=data[7];
	ElementObj.MaintItemDR=data[8];
	ElementObj.MItem=data[9];
	ElementObj.MaintItemCatDR=data[10];
	ElementObj.MItemCat=data[11];
	return ElementObj;
}
//**************************************
//���ؿؼ�����
/**
/**
*����DataGrid����
*/
function loadDataGridStore(DataGridID, queryParams){
	window.setTimeout(function(){
		var jQueryGridObj = jQuery("#" + DataGridID);
		jQuery.extend(jQueryGridObj.datagrid("options"),{
			//url : './dhceq.jquery.combo.easyui.csp',
			url:'dhceq.jquery.csp',
			queryParams : queryParams
		});
		jQueryGridObj.datagrid("load");
	},0);
}
/**
*����ComboGrid����
*/
function loadComboGridStore(ComboGridID, queryParams) {
	var jQueryComboGridObj = jQuery("#" + ComboGridID);
	var grid = jQueryComboGridObj.combogrid('grid');	// ��ȡ���ݱ�����
	var opts = grid.datagrid("options");
	//opts.url='./dhceq.jquery.grid.easyui.csp';
	opts.url='dhceq.jquery.csp';    
	grid.datagrid('load', queryParams);
}

//add by lmm 2020-04-27 
function setSelectValue(vElementID,rowData)
{
	if (vElementID=="MaintItem")
	{
		setElement("MaintItem",rowData.TDesc)
	}
	//setElement(vElementID+"DR",rowData.TRowID);
	ElementObj.MaintItemDR=rowData.TRowID
}
function clearData(vElementID)
{
	//setElement(vElementID+"DR","");	
	ElementObj.MaintItemDR=""
}
