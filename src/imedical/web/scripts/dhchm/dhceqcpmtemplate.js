/***************************
//文件名：        dhceqcPMTemplate.js
//文件功能描述:   PM模板明细维护
//创建人:         H_Haiman  HHM0032
//创建时间:       2016-01-13
//描述:           
//修改人:         
//修改时间；      
//修改描述:    
//***************************/
//全局变量
/************************************/
var SelectedRowID = 0;
var preRowID=0;  
var RowID=0   //全局变量 用于处理选中行
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

//界面入口
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

//初始化查询头面板
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
//列表面板
function initPMTemplatePanel(){
	jQuery("#tPMTemplate").datagrid({ 
	    fitColumns: true,
    	singleSelect:true,
    	loadMsg:'数据加载中……',
    	pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50], 
    	rownumbers: true,  //如果为true，则显示一个行号列。
		onBeforeLoad: function(param) {
			//目的是为了防止loadData时，设置url加载两次
			if(param.ArgCnt == undefined) {
				return false;
			}
		},  
    	columns:[[
		{field:'TDetail',title:'详细',algin:'center',width:20,formatter:DetailOperation},
    		{field:'TRowID',title:'RowID',width:50,hidden:true},    
        	{field:'TType',title:'类型',align:'center',width:90},
        	{field:'TName',title:'模板',align:'center',width:95},    
        	{field:'TCaption',title:'标题',align:'center',width:95},     
        	{field:'TNote',title:'注释',align:'center',width:100},
        	{field:'TFromDate',title:'开始日期',align:'center',width:100},
        	{field:'TToDate',title:'结束日期',align:'center',width:100},    
        	{field:'TRemark',title:'备注',align:'center',width:100},   
        	{field:'THold1',title:'THold1',align:'center',width:100,hidden:true},
        	{field:'THold2',title:'THold2',align:'center',width:100,hidden:true},
        	{field:'THold3',title:'THold3',align:'center',width:100,hidden:true},
        	{field:'TEquipRangeID',title:'TEquipRangeID',align:'center',width:75,hidden:true},   //Modefied  by zc0098 2021-1-29
			{field:'TPMRange',title:'模板范围',algin:'center',width:35,formatter:RangeOperation}   //Modefied  by zc0098 2021-1-29
    	]],
		onLoadSuccess:function(data){
			/*jQuery('#tPMTemplate').datagrid({
				rowStyler:function(index,row){
					//if(index>3)
					return 'background-color:pink;color:blue;font-weight:bold;';
				}
			});*/
		},
		onLoadError: function() {jQuery.messager.alert("错误", "加载列表错误.");},
		onSelect:onSelectRow,
		onClickRow:function(rowIndex, rowData){}
	});	
}
//*************************************
//加载面板数据
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
//按钮函数
//新增
function BAddClick(){
	
	if (checkMustItemNull()) return;	//add by lmm 2020-04-27 1289831
	//add by lmm 2018-11-06 begin 598959
	//var FromDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',jQuery('#FromDate').datebox('getValue'),'date');  //与后台交互
	//var ToDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',jQuery('#ToDate').datebox('getValue'),'date');  //与后台交互
	var FromDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',getElementValue("FromDate"),"date");  //与后台交互
	var ToDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',getElementValue("ToDate"),"date");  //与后台交互
	if(FromDate>ToDate)
	{
		alertShow("开始日期大于结束日期！")
		return;
	}
	//add by lmm 2018-11-06 end 598959
	var list="";
	list=GetPageValue('add');
	var returnData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplate','SaveData',list,'2');  //与后台交互
	if(returnData<0)
	{
		if(returnData==-3001)
		{
			alertShow('类型/模板数据有重复！');
			return;
		}		
		alertShow('新增失败!');
	}
	else
	{
		alertShow("操作成功!")
		jQuery('#tPMTemplate').datagrid("reload");
		Clear();
	}
}

//更新
function BUpdateClick(){
	//begin add by jyp 2018-03-12 544765
	if((RowID=="")||(RowID==0)){         
		alertShow('请选择一条数据!');         
		return true;
	}
	//End add by jyp 2018-03-12 544765
	if (checkMustItemNull()) return;	//add by lmm 2020-04-27 1289831
	//add by lmm 2018-11-06 begin 598959
	var FromDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',jQuery('#FromDate').datebox('getValue'),'date');  //与后台交互
	var ToDate=tkMakeServerCall('web.DHCEQCommon','TransValueFromPage',jQuery('#ToDate').datebox('getValue'),'date');  //与后台交互
	if(FromDate>ToDate)
	{
		alertShow("开始日期大于结束日期！")
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
				alertShow('类型/模板数据有重复！');
				return;
			}	
			alertShow('更新失败！')
		}
		else
		{
			alertShow("操作成功!")
			jQuery('#tPMTemplate').datagrid("reload");
			Clear();
		}
	}
	else
	{
		alertShow('请选择一行进行操作！');
	}
}

//删除
function BDelClick()
{
	if ((RowID==0)||(RowID==""))
	{
		alertShow('请选择需要进行操作的记录！');
		return
	}
	var truthBeTold = window.confirm("确定要删除吗？");//需求号：269196  add by csy 2016-10-10
    if (!truthBeTold) return;//需求号：269196  add by csy 2016-10-10
	if(RowID!=0){
		var returnData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplate','SaveData',RowID,'1')	
		if(returnData<0)
		{
			alertShow('删除失败！')
		}
		else
		{
			jQuery('#tPMTemplate').datagrid("reload");
			alertShow("删除成功") // 需求号：269196  add by csy 2016-10-10
			Clear();
		}
	}
}
function CheckEmpty(){
	if(jQuery('#Type').combobox('getValue')==0){
		alertShow('类型不能为空!');
		return true;
	}
	if(jQuery('#PMName').val()==""){
		alertShow('模板不能为空!');
		return true;
	}
	if(jQuery('#Caption').val()==""){
		alertShow('标题不能为空!');
		return true;
	}
	return false;
}
//**************************************
//处理行事件函数
function DetailOperation(value,rowData,rowIndex)
{
	var str='';
	//modified by csj 2020-02-17 需求号：1191838
	//"1":"保养","2":"检查","3":"维修"
	var type=rowData.TType=="保养"?"1":(rowData.TType=="检查"?"2":"3")
	//modify by lmm 2020-04-03
	str+='<a onclick="btnDetail('+rowData.TRowID+','+type+')" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></a>'
	//str='<a href="javascript:void(0);" onlick=btnDetail('+rowData.TRowID+')><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></a>'
	return str;
}
//modified by csj 2020-02-17 需求号：1191838
function btnDetail(id,type)
{
    var str="id="+id+"&type="+type;  //modified by csj 2020-02-24 需求号：1191838 修正
   	//window.open('dhceq.code.dhceqcpmtemplatelist.csp?'+str, '_blank', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=900,height=700,left=100,top=20');	
	//modify by lmm 2020-04-03	
	showWindow('dhceq.code.dhceqcpmtemplatelist.csp?'+str,'PM模板信息维护',"90%","90%")	//modified by csj 2020-02-28 需求号：1207883
}

//选中行处理
function onSelectRow(rowIndex, rowData){
    var selected=jQuery('#tPMTemplate').datagrid('getSelected');
    if (selected)
    {  
       var SelectedRowID=selected.TRowID;
        var Obj=fillData(selected.TRowID);
       if(preRowID!=SelectedRowID)
       {
	       	RowID=selected.TRowID ;   //全局变量
			jQuery('#Type').combobox('setValue',Obj.Type);
	     	jQuery('#PMName').val(Obj.Name);
	     	jQuery('#Caption').val(Obj.Caption);
	     	jQuery('#Note').val(Obj.Note);
	     	jQuery('#Remark').val(Obj.Remark); 
	     	jQuery('#FromDate').datebox('setValue',Obj.FromDate);  //modified by kdf 2018-03-14 需求号：564469
	     	jQuery('#ToDate').datebox('setValue',Obj.ToDate);      //modified by kdf 2018-03-14 需求号：564469
            preRowID=SelectedRowID;
       }
       else
       {
	       	RowID=0;
	       	Obj.ClearData();
			Clear();        		
            SelectedRowID = 0;
            preRowID=0;
            jQuery('#tPMTemplate').datagrid('unselectAll');  //add by wy 2018-2-11 清除选中背景色
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
//获取页面数据函数
function GetPageValue(type){
	var list="",Type='';
	var Type=jQuery('#Type').combobox('getValue');
	if(Type=='保养'){Type='1'};           //类型转换
	if(Type=='检查'){Type='2'};
	if(Type=='维修'){Type='3'};
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
//清空数据
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
//将js中Date对象转化为Ensemble中日期，即计算从1840.12.31起经过的日子
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
*加载DataGrid数据
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
*加载ComboGrid数据
*/
function loadComboGridStore(ComboGridID, queryParams) {
	var jQueryComboGridObj = jQuery("#" + ComboGridID);
	var grid = jQueryComboGridObj.combogrid('grid');	// 获取数据表格对象
	var opts = grid.datagrid("options");
	opts.url='dhceq.jquery.csp';    
	grid.datagrid('load', queryParams);
}
//add by HHM 2016-01-21 弹出窗口居中显示
function openwindow(url,str,iWidth,iHeight){
	//var iWidth=800;
	//var iHeight=400;
	//window.screen.height获得屏幕的高，window.screen.width获得屏幕的宽  
	var iTop = (window.screen.height-30-iHeight)/2; //获得窗口的垂直位置;  
	var iLeft = (window.screen.width-10-iWidth)/2; //获得窗口的水平位置; 
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.open(''+url+'?'+str+'', '_blank', 'width='+iWidth+',height='+iHeight+',left='+iLeft+',top='+iTop+'');	
}
//add by jyp 2017-09-28 需求号：456302//更换日期格式
function changeDateformat(Date)
{
	if (Date=="") return "";
	var date=Date.split("/")
	if(date.length==1) return Date;
	var temp=date[2]+"-"+date[1]+"-"+date[0];   //日期格式变换
	return temp;
}
//Modefied  by zc0098 2021-1-29
///描述：模板范围列内容
function RangeOperation(value,rowData,rowIndex)
{
	var str='';
	str+='<a onclick="btnRangeDetail(&quot;'+rowData.TRowID+"&quot;,&quot;"+rowData.TEquipRangeID+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></a>'

	return str;
}

//Modefied  by zc0098 2021-1-29
///描述：模板范围列弹窗
function btnRangeDetail(id,EquipRangeID)
{
	EquipRangeID=tkMakeServerCall("web.DHCEQ.Code.DHCEQCPMTemplate", "GetPMTemplateEquipRangeID",id);	// MZY0119	2574406		2022-04-07
    var str="&SourceType=3&SourceName=PMTemplate&SourceID="+id+"&EquipRangeDR="+EquipRangeID+"&vStatus=";  //页面跳转，传值变量设置
    showWindow('dhceq.plat.equiprange.csp?'+str,'PM模板范围限定',"90%","90%","","","","","",function (){location.reload();})	//modified by csj 2020-02-28 需求号：1207883		//czf 1776711 2021-03-03
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
