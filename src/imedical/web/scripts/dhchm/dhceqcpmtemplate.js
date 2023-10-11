/***************************
//�ļ�����        dhceqcPMTemplate.js
//�ļ���������:   PMģ����ϸά��
//������:         H_Haiman  HHM0032
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
//*************************************
var Obj={
	RID:"",
	Type:"",
	Name:"",
	Caption:"",
	Note:"",
	Remark:"",
	FromDate:"",
	ToDate:"",
	Hold1:"",
	Hold2:"",
	Hold3:"",
	ClearData:function(){
		this.RID="";
		this.Type="";
		this.Name="";
		this.Caption="";
		this.Note="";
		this.Remark="";
		this.FromDate="";
		this.ToDate="";
		this.Hold1="";
		this.Hold2="";
		this.Hold3="";
	}
}

//�������
jQuery(document).ready(function(){ 
	setTimeout("initDocument();", 50);
});
function initDocument(){
	//add by lmm 2020-04-27 1289831
	setRequiredElements("Type^PMName^Caption")	
	initMessage();
	initPanel();
	initPMTemplateData();	
}

//
function initPanel() {
	initTopPanel();
	initPMTemplatePanel();
	//modify by lmm 2020-04-03
	defindTitleStyle();
}

//��ʼ����ѯͷ���
function initTopPanel(){
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BUpdate").linkbutton({iconCls: 'icon-w-save'});
	jQuery("#BDel").linkbutton({iconCls: 'icon-w-close'});
	jQuery("#BAdd").on("click",BAddClick);
	jQuery("#BUpdate").on("click", BUpdateClick);
	jQuery("#BDel").on("click",BDelClick);
	jQuery("#BFind").on("click",BFindClick);	//MZY0096	2134951		2021-09-16
}
//*************************************
//�б����
function initPMTemplatePanel(){
	jQuery("#tPMTemplate").datagrid({ 
	    fitColumns: true,
    	singleSelect:true,
    	loadMsg:'���ݼ����С���',
    	pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50], 
    	rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		onBeforeLoad: function(param) {
			//Ŀ����Ϊ�˷�ֹloadDataʱ������url��������
			if(param.ArgCnt == undefined) {
				return false;
			}
		},  
    	columns:[[
		{field:'TDetail',title:'��ϸ',algin:'center',width:20,formatter:DetailOperation},
    		{field:'TRowID',title:'RowID',width:50,hidden:true},    
        	{field:'TType',title:'����',align:'center',width:90},
        	{field:'TName',title:'ģ��',align:'center',width:95},    
        	{field:'TCaption',title:'����',align:'center',width:95},     
        	{field:'TNote',title:'ע��',align:'center',width:100},
        	{field:'TFromDate',title:'��ʼ����',align:'center',width:100},
        	{field:'TToDate',title:'��������',align:'center',width:100},    
        	{field:'TRemark',title:'��ע',align:'center',width:100},   
        	{field:'THold1',title:'THold1',align:'center',width:100,hidden:true},
        	{field:'THold2',title:'THold2',align:'center',width:100,hidden:true},
        	{field:'THold3',title:'THold3',align:'center',width:100,hidden:true},
        	{field:'TEquipRangeID',title:'TEquipRangeID',align:'center',width:75,hidden:true},   //Modefied  by zc0098 2021-1-29
			{field:'TPMRange',title:'ģ�巶Χ',algin:'center',width:35,formatter:RangeOperation}   //Modefied  by zc0098 2021-1-29
    	]],
		onLoadSuccess:function(data){
			/*jQuery('#tPMTemplate').datagrid({
				rowStyler:function(index,row){
					//if(index>3)
					return 'background-color:pink;color:blue;font-weight:bold;';
				}
			});*/
		},
		onLoadError: function() {jQuery.messager.alert("����", "�����б����.");},
		onSelect:onSelectRow,
		onClickRow:function(rowIndex, rowData){}
	});	
}
//*************************************
//�����������
function initPMTemplateData(){
	var queryParams = new Object();
	var ClassName = "web.DHCEQ.Code.DHCEQCPMTemplate";
	var QueryName = "PMTemplate";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 ="" ; 
	queryParams.ArgCnt =1;	
	loadDataGridStore("tPMTemplate", queryParams);
}

//**************************************
//��ť����
//����
function BAddClick(){
	
	if (checkMustItemNull()) return;	//add by lmm 2020-04-27 1289831
	//add by lmm 2018-11-06 begin 598959
	//var FromDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',jQuery('#FromDate').datebox('getValue'),'date');  //���̨����
	//var ToDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',jQuery('#ToDate').datebox('getValue'),'date');  //���̨����
	var FromDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',getElementValue("FromDate"),"date");  //���̨����
	var ToDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',getElementValue("ToDate"),"date");  //���̨����
	if(FromDate>ToDate)
	{
		alertShow("��ʼ���ڴ��ڽ������ڣ�")
		return;
	}
	//add by lmm 2018-11-06 end 598959
	var list="";
	list=GetPageValue('add');
	var returnData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplate','SaveData',list,'2');  //���̨����
	if(returnData<0)
	{
		if(returnData==-3001)
		{
			alertShow('����/ģ���������ظ���');
			return;
		}		
		alertShow('����ʧ��!');
	}
	else
	{
		alertShow("�����ɹ�!")
		jQuery('#tPMTemplate').datagrid("reload");
		Clear();
	}
}

//����
function BUpdateClick(){
	//begin add by jyp 2018-03-12 544765
	if((RowID=="")||(RowID==0)){         
		alertShow('��ѡ��һ������!');         
		return true;
	}
	//End add by jyp 2018-03-12 544765
	if (checkMustItemNull()) return;	//add by lmm 2020-04-27 1289831
	//add by lmm 2018-11-06 begin 598959
	var FromDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',jQuery('#FromDate').datebox('getValue'),'date');  //���̨����
	var ToDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',jQuery('#ToDate').datebox('getValue'),'date');  //���̨����
	if(FromDate>ToDate)
	{
		alertShow("��ʼ���ڴ��ڽ������ڣ�")
		return;
	}
	//add by lmm 2018-11-06 end 598959
	var list="";
	list=GetPageValue('update');
	if(RowID!=0)
	{
		var returnData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplate','SaveData',list,'2');
		if(returnData<0)
		{
			if(returnData==-3001)
			{
				alertShow('����/ģ���������ظ���');
				return;
			}	
			alertShow('����ʧ�ܣ�')
		}
		else
		{
			alertShow("�����ɹ�!")
			jQuery('#tPMTemplate').datagrid("reload");
			Clear();
		}
	}
	else
	{
		alertShow('��ѡ��һ�н��в�����');
	}
}

//ɾ��
function BDelClick()
{
	if ((RowID==0)||(RowID==""))
	{
		alertShow('��ѡ����Ҫ���в����ļ�¼��');
		return
	}
	var truthBeTold = window.confirm("ȷ��Ҫɾ����");//����ţ�269196  add by csy 2016-10-10
    if (!truthBeTold) return;//����ţ�269196  add by csy 2016-10-10
	if(RowID!=0){
		var returnData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplate','SaveData',RowID,'1')	
		if(returnData<0)
		{
			alertShow('ɾ��ʧ�ܣ�')
		}
		else
		{
			jQuery('#tPMTemplate').datagrid("reload");
			alertShow("ɾ���ɹ�") // ����ţ�269196  add by csy 2016-10-10
			Clear();
		}
	}
}
function CheckEmpty(){
	if(jQuery('#Type').combobox('getValue')==0){
		alertShow('���Ͳ���Ϊ��!');
		return true;
	}
	if(jQuery('#PMName').val()==""){
		alertShow('ģ�岻��Ϊ��!');
		return true;
	}
	if(jQuery('#Caption').val()==""){
		alertShow('���ⲻ��Ϊ��!');
		return true;
	}
	return false;
}
//**************************************
//�������¼�����
function DetailOperation(value,rowData,rowIndex)
{
	var str='';
	//modified by csj 2020-02-17 ����ţ�1191838
	//"1":"����","2":"���","3":"ά��"
	var type=rowData.TType=="����"?"1":(rowData.TType=="���"?"2":"3")
	//modify by lmm 2020-04-03
	str+='<a onclick="btnDetail('+rowData.TRowID+','+type+')" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></a>'
	//str='<a href="javascript:void(0);" onlick=btnDetail('+rowData.TRowID+')><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></a>'
	return str;
}
//modified by csj 2020-02-17 ����ţ�1191838
function btnDetail(id,type)
{
    var str="id="+id+"&type="+type;  //modified by csj 2020-02-24 ����ţ�1191838 ����
   	//window.open('dhceq.code.dhceqcpmtemplatelist.csp?'+str, '_blank', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=900,height=700,left=100,top=20');	
	//modify by lmm 2020-04-03	
	showWindow('dhceq.code.dhceqcpmtemplatelist.csp?'+str,'PMģ����Ϣά��',"90%","90%")	//modified by csj 2020-02-28 ����ţ�1207883
}

//ѡ���д���
function onSelectRow(rowIndex, rowData){
    var selected=jQuery('#tPMTemplate').datagrid('getSelected');
    if (selected)
    {  
       var SelectedRowID=selected.TRowID;
        var Obj=fillData(selected.TRowID);
       if(preRowID!=SelectedRowID)
       {
	       	RowID=selected.TRowID ;   //ȫ�ֱ���
			jQuery('#Type').combobox('setValue',Obj.Type);
	     	jQuery('#PMName').val(Obj.Name);
	     	jQuery('#Caption').val(Obj.Caption);
	     	jQuery('#Note').val(Obj.Note);
	     	jQuery('#Remark').val(Obj.Remark); 
	     	jQuery('#FromDate').datebox('setValue',Obj.FromDate);  //modified by kdf 2018-03-14 ����ţ�564469
	     	jQuery('#ToDate').datebox('setValue',Obj.ToDate);      //modified by kdf 2018-03-14 ����ţ�564469
            preRowID=SelectedRowID;
       }
       else
       {
	       	RowID=0;
	       	Obj.ClearData();
			Clear();        		
            SelectedRowID = 0;
            preRowID=0;
            jQuery('#tPMTemplate').datagrid('unselectAll');  //add by wy 2018-2-11 ���ѡ�б���ɫ
       }
   }	
}
function fillData(rowid)
{
	if(rowid==""){return;}
	var data=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplate','GetPMTemplateByID',rowid);
	data=data.split("^");
	Obj.Type=data[1];
	Obj.Name=data[2];
	Obj.Caption=data[3];
	Obj.Note=data[4];
	Obj.Remark=data[5];
	Obj.FromDate=data[6];
	Obj.ToDate=data[7];
	Obj.Hold1=data[8];
	Obj.Hold2=data[9];
	Obj.Hold3=data[10];
	return Obj;
	
}
//**************************************
//��ȡҳ�����ݺ���
function GetPageValue(type){
	var list="",Type='';
	var Type=jQuery('#Type').combobox('getValue');
	if(Type=='����'){Type='1'};           //����ת��
	if(Type=='���'){Type='2'};
	if(Type=='ά��'){Type='3'};
	if(Type==''){Type=''}
	var PMName=jQuery('#PMName').val();
	var Caption=jQuery('#Caption').val();
	var Note=jQuery('#Note').val();
	var Remark=jQuery('#Remark').val();
	var FromDate=jQuery('#FromDate').datebox('getText');
	var ToDate=jQuery('#ToDate').datebox('getText'); //modify by lmm 2018-03-15 553289
	var Hold1="";
	var Hold2="";
	var Hold3="";
	if(type=="add"){list=""+"^"+Type+"^"+PMName+"^"+Caption+"^"+Note+"^"+Remark+"^"+FromDate+"^"+ToDate+"^"+Hold1+"^"+Hold2+"^"+Hold3;}
	if(type=="update"){list=RowID+"^"+Type+"^"+PMName+"^"+Caption+"^"+Note+"^"+Remark+"^"+FromDate+"^"+ToDate+"^"+Hold1+"^"+Hold2+"^"+Hold3;}
	if(type=="del"){list=RowID}
	return list;
}
//�������
function Clear()
{
	jQuery('#Type').combobox('setValue','');
	jQuery('#PMName').val('');
	jQuery('#Caption').val('');
	jQuery('#Note').val('');
	jQuery('#Remark').val('');
	jQuery('#FromDate').datebox('clear');
	jQuery('#ToDate').datebox('clear');
}
//��js��Date����ת��ΪEnsemble�����ڣ��������1840.12.31�𾭹�������
function ToEnsembleDate(date)
{
	if(date==""){return "";}
	var temp=date.split("-")
	date=new Date(temp[0],temp[1]-1,temp[2])
	var zerodate=new Date(1840,11,31)
	return (date.getTime()-zerodate.getTime())/1000/60/60/24
}
//**************************************
/**
/**
*����DataGrid����
*/
function loadDataGridStore(DataGridID, queryParams){
	window.setTimeout(function(){
		var jQueryGridObj = jQuery("#" + DataGridID);
		jQuery.extend(jQueryGridObj.datagrid("options"),{
			url : 'dhceq.jquery.csp',
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
	opts.url='dhceq.jquery.csp';    
	grid.datagrid('load', queryParams);
}
//add by HHM 2016-01-21 �������ھ�����ʾ
function openwindow(url,str,iWidth,iHeight){
	//var iWidth=800;
	//var iHeight=400;
	//window.screen.height�����Ļ�ĸߣ�window.screen.width�����Ļ�Ŀ�  
	var iTop = (window.screen.height-30-iHeight)/2; //��ô��ڵĴ�ֱλ��;  
	var iLeft = (window.screen.width-10-iWidth)/2; //��ô��ڵ�ˮƽλ��; 
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.open(''+url+'?'+str+'', '_blank', 'width='+iWidth+',height='+iHeight+',left='+iLeft+',top='+iTop+'');	
}
//add by jyp 2017-09-28 ����ţ�456302//�������ڸ�ʽ
function changeDateformat(Date)
{
	if (Date=="") return "";
	var date=Date.split("/")
	if(date.length==1) return Date;
	var temp=date[2]+"-"+date[1]+"-"+date[0];   //���ڸ�ʽ�任
	return temp;
}
//Modefied  by zc0098 2021-1-29
///������ģ�巶Χ������
function RangeOperation(value,rowData,rowIndex)
{
	var str='';
	str+='<a onclick="btnRangeDetail(&quot;'+rowData.TRowID+"&quot;,&quot;"+rowData.TEquipRangeID+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></a>'

	return str;
}

//Modefied  by zc0098 2021-1-29
///������ģ�巶Χ�е���
function btnRangeDetail(id,EquipRangeID)
{
	EquipRangeID=tkMakeServerCall("web.DHCEQ.Code.DHCEQCPMTemplate", "GetPMTemplateEquipRangeID",id);	// MZY0119	2574406		2022-04-07
    var str="&SourceType=3&SourceName=PMTemplate&SourceID="+id+"&EquipRangeDR="+EquipRangeID+"&vStatus=";  //ҳ����ת����ֵ��������
    showWindow('dhceq.plat.equiprange.csp?'+str,'PMģ�巶Χ�޶�',"90%","90%","","","","","",function (){location.reload();})	//modified by csj 2020-02-28 ����ţ�1207883		//czf 1776711 2021-03-03
}
//MZY0096	2134951		2021-09-16
function BFindClick()
{
	var queryParams = new Object();
	var ClassName = "web.DHCEQ.Code.DHCEQCPMTemplate";
	var QueryName = "PMTemplate";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = jQuery('#Type').combobox('getValue');
	queryParams.Arg2 = jQuery('#PMName').val();
	queryParams.Arg3 = jQuery('#Caption').val();
	queryParams.Arg4 = jQuery('#Note').val();
	queryParams.Arg5 = jQuery('#FromDate').datebox('getValue');
	queryParams.Arg6 = jQuery('#ToDate').datebox('getValue');
	queryParams.ArgCnt =6;	
	loadDataGridStore("tPMTemplate", queryParams);
}
