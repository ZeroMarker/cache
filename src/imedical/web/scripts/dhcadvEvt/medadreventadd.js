/// Creator: liangqiang
/// CreateDate: 2015-10-09
//  Descript: 不良事件维护

var editRow="", editqsRow="",edititmRow="" ,nodeArr=[],count = 0;//当前编辑行号
var url="dhcadv.repaction.csp";
var dataArray = [{"value":"1","text":'安全组'}, {"value":"2","text":'科室'}, {"value":"3","text":'人员'}, {"value":"5","text":'大科'}]; //, {"value":"4","text":'全院'}
var SecFlagArray= [{"value":"1","text":'仅自己'}, {"value":"2","text":'仅本科室'}, {"value":"3","text":'全院'}];
var AssessFlagArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  //wangxuejian 2016-10-18
var ShareFlagArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  
var FocusFlagArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  
var FileFlagArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  
var CaseShareFlagArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  
var DeleteFlagArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  
var CancelFlagArray=[{"value":"Y","text":'是'}, {"value":"N","text":'否'}];  
var Active = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
var titleNotes=""; //'<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;color:red;">[双击行即可编辑]</span>';
var Levelrowid="";
var level=0,parentid="";
var HospDr="";
$(function(){
    InitHosp(); 	//初始化医院 多院区改造 cy 2021-04-09
    InitTree();
	InitAdrEvent();
	InitQuerySec();
	InitDefault();
})

function InitTree(){
	//事件分类元素树的加载     
	$('#tree').tree({
		url: 'dhcapp.broker.csp'+"?ClassName=web.DHCADVMEDEVENTADD&MethodName=jsonCheckType&id="+"Root"+"&hospdr="+HospDr,  ///默认传参 "Root"  加载根目录和一级事件分类数据
    	lines:true,
    	onClick: function(node){
	    	level=node.level;
			level++;
			parentid=node.id; 
			var tab = $('#tabs').tabs('getTab',0);
			if(parentid=="Root"){
				$('#tabs').tabs('update', {tab: tab,options: {title: '事件分类'} });
			}else{
				$('#tabs').tabs('update', {tab: tab,options: {title: '事件子分类'} });
			}
			Query();		
		},
		onLoadSuccess: function(node, data){
				for (var i=0;i<nodeArr.length;i++){
					var node = $('#tree').tree('find', nodeArr[i]);
					if (node != null){
						$('#tree').tree('expand', node.target);
						count = count + 1;
					}
				}
				if (count == nodeArr.length+1){
					nodeArr=[];
				}
				if(parentid!="")
				{
					var node = $('#tree').tree('find', parentid);	//找到id为tree这个树的节点id为parentid的对象
					if(node!=null)
					{
						$('#tree').tree('select', node.target);			//设置选中该节点

					}
				}				
		}

	});
}
// 初始化医院 多院区改造 cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvQuerySec"); 
	HospDr=hospComp.getValue(); //cy 2021-04-09
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///选中事件
		HospDr=hospComp.getValue(); //cy 2021-04-09
		QueryTree();
		Query();
	}
	

}
// 查询树 cy 2021-04-13  
function QueryTree(){
	$('#tree').tree({
		url: 'dhcapp.broker.csp'+"?ClassName=web.DHCADVMEDEVENTADD&MethodName=jsonCheckType&id="+"Root"+"&hospdr="+HospDr  ///默认传参 "Root"  加载根目录和一级事件分类数据
	})
}
function InitDefault(){
	$('#tabs').tabs({    
	    onSelect:function(title){    
			Query();
	    }    
	}); 
	$("#eventdg").datagrid('loadData',{total:0,rows:[]}); 
}

function Query(){
	var dgurl=""; 
	if((parentid=="Root")||(parentid=="")){
		dgurl=url+"?action=QueryAdrEvent";
		$('#insert').show();
		$('#insertitm').hide();
	}else{
		$('#insert').hide();
		$('#insertitm').show();
		dgurl=url+"?action=QueryAdrEventItm";
	}
	
	$('#eventdg').datagrid({   //子项的加载      wangxuejian 2018-08-21
		url:dgurl,	
		queryParams:{
			params:parentid,
			HospDr:HospDr
		}
	});	 
	$('#querysecdg').datagrid({
		url:'dhcadv.repaction.csp?action=GetQuerySec',	
		queryParams:{
			params:parentid,
			HospDr:HospDr
		}
	});
}
function InitAdrEvent(){
	//是否可用标志
	var activeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}

	// 定义columns
	var columns=[[
		{field:'Code',title:'代码',width:150,editor:texteditor},
		{field:"Desc",title:'描述',width:150,editor:texteditor},
		{field:'Level',title:'级别',width:50,hidden:true},
		{field:"Levelrowid",title:'上一级别的rowid',width:100,hidden:true},
		{field:'Active',title:'是否可用',width:60,formatter:formatLink,editor:activeEditor},
		{field:"ID",title:'ID',width:50,align:'center',hidden:false}
	]];	
	
	// 定义datagrid
	$('#eventdg').datagrid({
		title:'',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) {
	            if(CheckEdit("eventdg",editRow)){
		        	$.messager.alert("提示","请填写必填项信息!"); 
					return false;	    
	            }
            	$("#eventdg").datagrid('endEdit', editRow);  
			}
            $("#eventdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        } 
		
	});
	
	initScroll("#eventdg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#insertitm').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
}


// 插入新行
function insertRow()
{
	if((parentid=="")){
		$.messager.alert("提示","请选择一条事件分类树节点!"); 
		return false;
	}
	if(editRow>="0"){
		if(CheckEdit("eventdg",editRow)){
        	$.messager.alert("提示","请填写必填项信息!"); 
			return false;	    
        }
		$("#eventdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	var rows = $("#eventdg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
	} 
	
	$("#eventdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: '',Level:level,Levelrowid: parentid,Active: 'Y'}
	});
	$("#eventdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#eventdg").datagrid('getSelections'); //选中要删除的行
	var dgurl=""
	if(parentid=="Root"){
		dgurl=url+'?action=DelAdrEvent';
	}else {
		dgurl=url+'?action=DelAdrEventItm';
	}
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(dgurl,{"params":rows[0].ID}, function(data){
					if(data==0){
						$.messager.alert('提示','删除成功');	
					}else if(data==-1){
						$.messager.alert('提示','此数据存在使用信息，不可删除');	
					}else{
						$.messager.alert('提示','删除失败');
					}
					$('#eventdg').datagrid('reload'); //重新加载
					RefreshTree(parentid);
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function saveRow()
{
	if(editRow>="0"){
		$("#eventdg").datagrid('endEdit', editRow);
	}
 	
	var rows = $("#eventdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		if(parentid=="Root"){
			var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Active;
		}else {
			var tmp=rows[i].ID+"^"+parentid+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Level+"^"+rows[i].Levelrowid+"^"+rows[i].Active;
		}
		
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	var dgurl=""
	if(parentid=="Root"){
		dgurl=url+'?action=SaveAdrEvent';
	}else {
		dgurl=url+'?action=SaveAdrEventItm';
	}

	//保存数据
	$.post(dgurl,{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','代码重复,请核实后再试','warning');
		}else {
			$.messager.alert('提示','操作失败','warning');
		}
		$('#eventdg').datagrid('reload'); //重新加载
		//$('#tree').tree('reload'); //重新加载
		RefreshTree(parentid);
	});
}
/// 刷新树 获取选中节点的所有父节点ID
function RefreshTree(parentid){

	runClassMethod("web.DHCADVMEDEVENTADD","GetItmLevCon",{"ItmID":parentid},function(jsonString){
		if(jsonString){
			nodeArr = jsonString.split("^");
			count = 0;
		}
	},'',false);
	$('#tree').tree('reload');
	return;
}
// 编辑格
var texteditor={
	type: 'validatebox',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

/// ================================================================================
/// =====================================可查看权限配置=============================
function InitQuerySec()
{
	//设置其为可编辑
	var editPoint={
		type: 'combobox',     //设置编辑格式
		options: {
			required:true,
			valueField: "value",
			textField: "text",
			mode:'remote',  //必须设置这个属性 2017-08-01 cy 修改下拉框模糊检索
			url: '',
			onSelect:function(option){
				var ed=$("#querysecdg").datagrid('getEditor',{index:editqsRow,field:'PointID'});
				$(ed.target).val(option.value);  //设置科室ID
				var ed=$("#querysecdg").datagrid('getEditor',{index:editqsRow,field:'Pointer'});
				$(ed.target).combobox('setValue', option.text);  //设置科室Desc
			}
		}
	}
	//权限范围标志
	var SecFlagEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:SecFlagArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#querysecdg").datagrid('getEditor',{index:editqsRow,field:'SecFlagID'});
				$(ed.target).val(option.value);
				var ed=$("#querysecdg").datagrid('getEditor',{index:editqsRow,field:'SecFlag'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	//评估权限范围标志      wangxuejian 2016-10-18
	var AssessFlagEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:AssessFlagArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //设置容器高度自动增长
		}
	}
	//分享权限范围标志      wangxuejian 2016-10-18
	var ShareFlagEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:ShareFlagArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}
	//重点关注权限范围标志      wangxuejian 2016-10-18
	var FocusFlagEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:FocusFlagArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}
	//归档权限范围标志      
	var FileFlagEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:FileFlagArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}
	//案例共享权限范围标志      
	var CaseShareFlagEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:CaseShareFlagArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}
	//删除权限范围标志      
	var DeleteFlagEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:DeleteFlagArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}
	//作废权限范围标志     
	var CancelFlagEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:CancelFlagArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}
	
	// 定义columns
	var columns=[[		
		{field:"HospDr",title:'医院id',width:90,align:'center',hidden:true},
		{field:"RepTypeDr",title:'报告类型Dr',width:90,align:'center',hidden:true},
		{field:'TypeID',title:'TypeID',width:90,editor:'text',hidden:true},
		{field:"Type",title:'角色',width:80,editor:texteditor,
			editor: {  //设置其为可编辑
				type: 'combobox',//设置编辑格式
				options: {
					data:dataArray,
					valueField: "value", 
					textField: "text",
					required:true,
					panelHeight:"auto",  //设置容器高度自动增长
					onSelect:function(option){
						///设置类型值
						var ed=$("#querysecdg").datagrid('getEditor',{index:editqsRow,field:'TypeID'});
						$(ed.target).val(option.value);  //设置科室ID
						var ed=$("#querysecdg").datagrid('getEditor',{index:editqsRow,field:'PointID'});
						$(ed.target).val(" ");	//乔庆澳 2016/7/12
						var ed=$("#querysecdg").datagrid('getEditor',{index:editqsRow,field:'Type'});
						$(ed.target).combobox('setValue', option.text);  //设置科室Desc
						///设置级联指针
						var paramType=option.value+"^"+LgGroupID;  //类型^安全组
						var ed=$("#querysecdg").datagrid('getEditor',{index:editqsRow,field:'Pointer'});
						var url='dhcadv.repaction.csp?action=GetSSPPoint&params='+paramType+'&HospDr='+HospDr;
						$(ed.target).combobox('setValue','');  //乔庆澳 16.7.13
						$(ed.target).combobox('reload',url);
						
						
					} 
				}
			}
		},
		{field:'Pointer',title:'指向',width:200,editor:editPoint},
		{field:'PointID',title:'PointID',width:130,editor:'text',hidden:true},
		{field:'SecFlag',title:'权限',width:80,editor:SecFlagEditor},
		{field:'SecFlagID',title:'SecFlagID',width:150,editor:'text',hidden:true},
		{field:'AssessFlag',title:'评估权限',width:100,formatter:formatLink,editor:AssessFlagEditor},  //wangxuejian 2016/10/18
		{field:'ShareFlag',title:'分享权限',width:100,formatter:formatLink,editor:ShareFlagEditor,hidden:false},  //ylp 2017/12/11
		{field:'FocusFlag',title:'重点关注权限',width:100,formatter:formatLink,editor:FocusFlagEditor,hidden:false},  //ylp 2017/12/11
		{field:'FileFlag',title:'归档权限',width:100,formatter:formatLink,editor:FileFlagEditor,hidden:false},  //ylp 2017/12/11
		{field:'CaseShareFlag',title:'案例共享权限',width:100,formatter:formatLink,editor:CaseShareFlagEditor,hidden:false},  //ylp 2017/12/11
		{field:'DeleteFlag',title:'删除权限',width:100,formatter:formatLink,editor:DeleteFlagEditor,hidden:false},  //ylp 2017/12/11
		{field:'CancelFlag',title:'作废权限',width:100,formatter:formatLink,editor:CancelFlagEditor,hidden:false},  //ylp 2017/12/11
		{field:"ID",title:'ID',width:90,align:'center',hidden:false}
	]];
	// 定义datagrid
	$('#querysecdg').datagrid({
		title:'',//可查看权限配置
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		//pageSize:40,        // 每页显示的记录条数
		//pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		//pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editqsRow != "")||(editqsRow == "0")) {
	            if(CheckEdit("querysecdg",editqsRow)){
		        	$.messager.alert("提示","请填写必填项信息!"); 
					return false;	    
	            }
            	$("#querysecdg").datagrid('endEdit', editqsRow);
			}
            $("#querysecdg").datagrid('beginEdit', rowIndex); 
            editqsRow = rowIndex; 
            
			///设置级联指针 huaxiaoying 2018-01-25 st
			var paramType=rowData.TypeID+"^"+LgGroupID;  //类型^安全组
			var ed=$("#querysecdg").datagrid('getEditor',{index:editqsRow,field:'Pointer'});
			var url='dhcadv.repaction.csp?action=GetSSPPoint&params='+paramType+'&HospDr='+HospDr;
			$(ed.target).combobox('reload',url); //ed
        
        }
	});
	
	initScroll("#querysecdg");//初始化显示横向滚动条
	
	//按钮绑定事件
    $('#insquerysec').bind('click',insquerysecRow); 
    $('#delquerysec').bind('click',delquerysecRow);
    $('#savquerysec').bind('click',savquerysecRow);
	
}

// 插入新行
function insquerysecRow()
{
	//var ttt=$("#querysecdg").datagrid('selectRow',editqsRow)
	if((parentid=="")||(parentid=="Root")){
		$.messager.alert("提示","请选择一条事件分类树节点!"); 
		return false;
	}
	if(editqsRow>="0"){
		if(CheckEdit("querysecdg",editqsRow)){
        	$.messager.alert("提示","请填写必填项信息!"); 
			return false;	    
        }
		$("#querysecdg").datagrid('endEdit', editqsRow);//结束编辑，传入之前编辑的行
	}
	
	//////////////////////////////////////////////////////
	var rows = $("#querysecdg").datagrid('getChanges');    //乔庆澳 2016/7/22
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Type=="")||(rows[i].Pointer=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return;
		}		
	} 
	$("#querysecdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Type:'',Point: '',SecFlag:''  ,AssessFlag:'N',ShareFlag:'N',FocusFlag:'N',FileFlag:'N',CaseShareFlag:'N',DeleteFlag:'N',CancelFlag:'N',HospDr:HospDr}
	});
	$("#querysecdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editqsRow=0;
}

// 删除选中行
function delquerysecRow()
{
	var rows = $("#querysecdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelQuerySec',{"params":rows[0].ID}, function(data){
					$('#querysecdg').datagrid('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function savquerysecRow()
{
	
	if(editqsRow>="0"){
		$("#querysecdg").datagrid('endEdit', editqsRow);
		if(CheckEdit("querysecdg",editqsRow)){
			$.messager.alert("提示","请填写必填项信息!"); 
			return false;	    
		}
    }
	var rows = $("#querysecdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((parentid=="")||(parentid=="Root")){
			$.messager.alert("提示","请选择一条事件分类树节点!"); 
			return false;
		}
		if(rows[i].ShareFlag==undefined){   //sufan 2018-07-16
			rows[i].ShareFlag="";
		}
		if(rows[i].FocusFlag==undefined){
			rows[i].FocusFlag="";
		}
		if(rows[i].FileFlag==undefined){
			rows[i].FileFlag="";
		}
		if(rows[i].CaseShareFlag==undefined){
			rows[i].CaseShareFlag="";
		}
		if(rows[i].DeleteFlag==undefined){
			rows[i].DeleteFlag="";
		}
		if(rows[i].CancelFlag==undefined){
			rows[i].CancelFlag="";
		}
		if((rows[i].Type=="")||(rows[i].Pointer=="")||(rows[i].SecFlag=="")||(rows[i].AssessFlag=="")||(rows[i].ShareFlag=="")||(rows[i].FocusFlag=="")||(rows[i].FileFlag=="")||(rows[i].CaseShareFlag=="")||(rows[i].DeleteFlag=="")||(rows[i].CancelFlag=="")){ //wangxuejian 2016/10/18
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+parentid+"^"+rows[i].TypeID+"^"+rows[i].PointID+"^"+rows[i].SecFlagID+"^"+rows[i].AssessFlag+"^"+rows[i].ShareFlag+"^"+rows[i].FocusFlag+"^"+rows[i].FileFlag+"^"+rows[i].CaseShareFlag+"^"+rows[i].DeleteFlag+"^"+rows[i].CancelFlag+"^"+rows[i].HospDr;// wangxuejian 2016/10/18
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	//保存数据
	$.post('dhcadv.repaction.csp?action=SaveQuerySec',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert("提示","保存成功!");		
		}else if((data==-1)||data==-2){
			$.messager.alert("提示","记录重复，保存失败!");	
			//return;	//2017-03-17 保存失败，刷新字典表	
		}else{
			$.messager.alert("提示","保存失败!");
			//return;	//2017-03-17 保存失败，刷新字典表	
		}
		$('#querysecdg').datagrid('reload'); //重新加载
	});
}
//检查编辑行是否编辑完全 2018-07-18 cy
function CheckEdit(id,index){
	var flag=0;
	var editors = $('#'+id).datagrid('getEditors', index); 
	for (i=0;i<editors.length;i++){
		if(((editors[i].type=="validatebox")&&(editors[i].target.val()==""))|| ((editors[i].type=="text")&&(editors[i].target.val()==""))||((editors[i].type=="combobox")&&(editors[i].target.combobox('getText')==""))){
			flag=-1;
			return flag;	
		}
	}
	return flag; 
} 
//YN转换是否
function formatLink(value,row,index){
	if (value=='Y'){
		return '是';
	}else if (value=='N'){
		return '否';
	}
}
/// 事件分类复制 2021-6-30 cy
function EventCopy(){
	var rowsData = $("#eventdg").datagrid('getSelected');
	if (rowsData == null) {
		$.messager.alert("提示","请选择事件分类!");
		return;	
	}
	$("#copyCode").val("");
	$("#copyName").val("");
	$('#copydialog').dialog("open");

}
/// 事件分类复制保存 2021-6-30 cy
function SaveEventCopy(){
	
	if($("#copyEvent").form('validate')){
		var rowsData = $("#eventdg").datagrid('getSelected');
		runClassMethod("web.DHCADVMEDEVENTADD","CopyEventInfo",{
		'CopyID':rowsData.ID,'Code':$("#copyCode").val(),'Desc':$("#copyName").val(),'ParentID':parentid},
		function(data){
			if(data==0){
				$.messager.alert("提示","保存成功");		
			}else if((data==-1)||data==-2){
				$.messager.alert("提示","代码重复，保存失败");	
				//return;	//2017-03-17 保存失败，刷新字典表	
			}else{
				$.messager.alert("提示","保存失败");
				//return;	//2017-03-17 保存失败，刷新字典表	
			}
			$('#copydialog').dialog("close");
			$('#eventdg').datagrid('reload'); //重新加载
			RefreshTree(parentid);
		},"text");
	}
	
}
